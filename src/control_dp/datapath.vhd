----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : datapath.vhd                                             
----------------------------------------------------------------------
-- Descrição : Fluxo de Dados do MIPS
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all; use IEEE.std_logic_ARITH.all;

entity datapath is  -- MIPS datapath
  port (
    clk, reset:        in  std_logic;
    memtoreg, pcsrc:   in  std_logic;
    alusrc, regdst:    in  std_logic;
    regwrite, jump:    in  std_logic;
    alucontrol:        in  std_logic_vector(2 downto 0);
    zero:              out std_logic;
    pc:                buffer std_logic_vector(31 downto 0);
    instr:             in  std_logic_vector(31 downto 0);
    aluout, writedata: buffer std_logic_vector(31 downto 0);
    readdata:          in  std_logic_vector(31 downto 0));
end;

architecture struct of datapath is

  -- pipeline signal related to Control Unit
  signal s_RegWriteD  ,   s_RegWriteE   , s_RegWriteM , s_RegWriteW : std_logic;
  signal s_MemtoRegD  ,   s_MemtoRegE   , s_MemtoRegM , s_MemtoRegW : std_logic;
  signal s_MemWriteD  ,   s_MemWriteE   , s_MemWriteM               : std_logic;
  signal s_BranchD    ,   s_BranchE     , s_BranchM                 : std_logic;
  signal s_ALUControlD,   s_ALUControlE                             : std_logic_vector(2 downto 0);
  signal s_ALUSrcD    ,   s_ALUSrcE                                 : std_logic;
  signal s_RegDstD    ,   s_RegDstE                                 : std_logic;
  signal s_PCSrcM                                                   : std_logic;


  signal s_StallF, s_StallD: std_logic;
  signal s_BranchD: std_logic;
  signal s_ForwardAD, s_ForwardBD: std_logic;
  signal s_FlushE: std_logic;
  signal s_ForwardAE, s_ForwardBE: std_logic_vector(1 downto 0);
  signal s_MemtoRegE, s_RegWriteE: std_logic;
  signal s_MemtoRegM, s_RegWriteM: std_logic;
  signal s_RegWriteW: std_logic;
  signal s_RsD, s_RtD: std_logic_vector(4 downto 0);
  signal s_RsE, s_RtE: std_logic_vector(4 downto 0);


  component alu
    port (
      a, b:       in  std_logic_vector(31 downto 0);
      alucontrol: in  std_logic_vector(2 downto 0);
      result:     buffer std_logic_vector(31 downto 0);
      zero:       out std_logic
      );
  end component;

  component regfile
    port (
      clk:           in  std_logic;
      we3:           in  std_logic;
      ra1, ra2, wa3: in  std_logic_vector(4 downto 0);
      wd3:           in  std_logic_vector(31 downto 0);
      rd1, rd2:      out std_logic_vector(31 downto 0)
    );
  end component;

  component adder
    port (
      a, b: in  std_logic_vector(31 downto 0);
      y:    out std_logic_vector(31 downto 0));
  end component;

  component sl2
    port (
      a: in  std_logic_vector(31 downto 0);
      y: out std_logic_vector(31 downto 0)
    );
  end component;

  component signext
    port (
      a: in  std_logic_vector(15 downto 0);
      y: out std_logic_vector(31 downto 0)
    );
  end component;

  component flopr
    generic (
      width: integer
    );
    port (
      clk, reset: in  std_logic;
      d:          in  std_logic_vector(width-1 downto 0);
      q:          out std_logic_vector(width-1 downto 0)
    );
  end component;

  component mux2
    generic (
      width: integer
    );
    port (
      d0, d1: in  std_logic_vector(width-1 downto 0);
      s:      in  std_logic;
      y:      out std_logic_vector(width-1 downto 0)
    );
  end component;

  signal writereg:           std_logic_vector(4 downto 0);
  signal pcjump, pcnext,
         pcnextbr, pcplus4,
         pcbranch:           std_logic_vector(31 downto 0);
  signal signimm, signimmsh: std_logic_vector(31 downto 0);
  signal srca, srcb, result: std_logic_vector(31 downto 0);
begin
  -- next PC logic
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";

  pcreg: flopr 
  generic map(32) 
  port map (
    clk, 
    reset, 
    pcnext, 
    pc
  );

  pcadd1: adder 
  port map (
    pc, 
    X"00000004", 
    pcplus4
  );

  immsh: sl2 
  port map (
    signimm, 
    signimmsh
  );

  pcadd2: adder 
  port map (
    pcplus4, 
    signimmsh, 
    pcbranch
  );

  pcbrmux: mux2 
  generic map(32) 
  port map (
    pcplus4, 
    pcbranch,
    pcsrc,
    pcnextbr
  );

  pcmux: mux2 
  generic map(32) 
  port map (
    pcnextbr, 
    pcjump, 
    jump, 
    pcnext
  );

  -- register file logic
  rf: regfile 
  port map (
    clk,
    regwrite,
    instr(25 downto 21),
    instr(20 downto 16),
    writereg,
    result,
    srca,
    writedata
  );
        
  wrmux: mux2 
  generic map(5) 
  port map (
    instr(20 downto 16),
    instr(15 downto 11),
    regdst, 
    writereg
  );

  resmux: mux2 
  generic map(32) 
  port map (
    aluout,
    readdata,
    memtoreg, 
    result
  );

  se: signext 
  port map (
    instr(15 downto 0), 
    signimm
  );

  -- ALU logic
  srcbmux: mux2 
  generic map(32) 
  port map (
    writedata,
    signimm,
    alusrc,
    srcb
  );

  mainalu: alu 
  port map (
    srca, 
    srcb, 
    alucontrol, 
    aluout, 
    zero
  );

end;
