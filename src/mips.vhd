----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : mips.vhd                                             
----------------------------------------------------------------------
-- Descrição : Entidade principal do MIPS
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity mips is
  port (
    clk, reset:        in  std_logic;
    pc:                out std_logic_vector(31 downto 0);
    instr:             in  std_logic_vector(31 downto 0);
    memwrite:          out std_logic;
    aluout, writedata: out std_logic_vector(31 downto 0);
    readdata:          in  std_logic_vector(31 downto 0)
  );
end;

architecture struct of mips is
  component controller
    port (
      op, funct:          in  std_logic_vector(5 downto 0);
      zero:               in  std_logic;
      memtoreg, memwrite: out std_logic;
      pcsrc, alusrc:      out std_logic;
      regdst, regwrite:   out std_logic;
      jump:               out std_logic;
      alucontrol:         out std_logic_vector(2 downto 0)
    );
  end component;
  
  component datapath is  -- MIPS datapath
    port (
      clk, reset:         in  std_logic;
      -- from instruction memory
      InstrF: in std_logic_vector(31 downto 0);
      -- from Data memory
      ReadDataM:          in  std_logic_vector(31 downto 0);
      -- from controller
      RegWriteD:    in std_logic;
      MemtoRegD:    in std_logic;
      MemWriteD:    in std_logic;
      ALUControlD:  in std_logic_vector(2 downto 0);
      ALUSrcD:      in std_logic;
      RegDstD:      in std_logic;
      PCSrcD:       in std_logic;
      -- fom hazard unit
      StallF, StallD:     in  std_logic;
      ForwardAD, ForwardBD: in std_logic;
      FlushE:             in  std_logic;
      ForwardAE, ForwardBE: in std_logic_vector(1 downto 0);
      -- to instruction memory
      PCF:  out std_logic_vector(31 downto 0);
      -- to hazard unit
      RegWriteE, RegWriteM, RegWriteW: out  std_logic;
      MemtoRegE, MemtoRegM: out std_logic;
      RsD, RtD, RsE, RtE: out  std_logic_vector(4 downto 0);
      WriteRegE, WriteRegM, WriteRegW: out std_logic_vector(4 downto 0);
      -- to controller
      EqualD:             out  std_logic;
      Op, Funct: out  std_logic_vector(5 downto 0);
      -- to Data memory
      MemWriteM:  out std_logic;
      ALUOutM:    out std_logic_vector(31 downto 0);
      WriteDataM: out std_logic_vector(31 downto 0)
    );
  end component;

  component hazard_unit is
    port (
      clock:      in  std_logic;
      RsD:        in  std_logic_vector(4 downto 0);
      RtD:        in  std_logic_vector(4 downto 0);
      RsE:        in  std_logic_vector(4 downto 0);
      RtE:        in  std_logic_vector(4 downto 0);
      BranchD:    in  std_logic;
      WriteRegE:  in  std_logic_vector(4 downto 0);
      MemtoRegE:  in  std_logic;
      RegWriteE:  in  std_logic;
      WriteRegM:  in  std_logic_vector(4 downto 0);
      MemtoRegM:  in  std_logic;
      RegWriteM:  in  std_logic;
      WriteRegW:  in  std_logic_vector(4 downto 0);
      RegWriteW:  in  std_logic;
      StallF:     out std_logic;
      StallD:     out std_logic;
      ForwardAD:  out std_logic;
      ForwardBD:  out std_logic;
      FlushE:     out std_logic;
      ForwardAE:  out std_logic_vector(1 downto 0);
      ForwardBE:  out std_logic_vector(1 downto 0)
    );
  end component;

  signal s_EqualD, s_MemtoRegD, s_MemWriteD: std_logic;
  signal s_PCSrcD, s_ALUSrcD, s_RegDstD, s_RegWriteD, s_BranchD: std_logic;

  signal s_ALUControlD: std_logic_vector(2 downto 0);

  signal s_StallF, s_StallD, s_ForwardAD, s_ForwardBD, s_FlushE: std_logic;
  signal s_ForwardAE, s_ForwardBE: std_logic_vector(1 downto 0);  

  signal s_RegWriteE, s_RegWriteM, s_RegWriteW: std_logic;
  signal s_MemtoRegE, s_MemtoRegM:std_logic;
  signal s_RsD, s_RtD, s_RsE, s_RtE: std_logic_vector(4 downto 0);
  signal s_WriteRegE, s_WriteRegM, s_WriteRegW: std_logic_vector(4 downto 0);

  signal s_Op, s_Funct: std_logic_vector(5 downto 0);
begin
  cont: controller 
  port map (
    op => s_Op,
    funct => s_Funct,
    zero => s_EqualD,
    memtoreg => s_MemtoRegD,
    memwrite => s_MemWriteD,
    pcsrc => s_PCSrcD,
    alusrc => s_ALUSrcD,
    regdst => s_RegDstD,
    regwrite => s_RegWriteD,
    jump => s_BranchD,
    alucontrol => s_ALUControlD
  );

  dp: datapath 
  port map (
    clk => clk,
    reset => reset,
    -- from instruction memory
    InstrF => instr,
    -- from Data memory
    ReadDataM => readdata,
    -- from controller
    RegWriteD => s_RegWriteD,
    MemtoRegD => s_MemtoRegD,
    MemWriteD => s_MemWriteD,
    ALUControlD => s_ALUControlD,
    ALUSrcD => s_ALUSrcD,
    RegDstD => s_RegDstD,
    PCSrcD => s_PCSrcD,
    -- fom hazard unit
    StallF => s_StallF,
    StallD => s_StallD,
    ForwardAD => s_ForwardAD,
    ForwardBD => s_ForwardBD,
    FlushE => s_FlushE,
    ForwardAE => s_ForwardAE,
    ForwardBE => s_ForwardBE,
    -- to instruction memory
    PCF => pc,
    -- to hazard unit
    RegWriteE => s_RegWriteE,
    RegWriteM => s_RegWriteM,
    RegWriteW => s_RegWriteW,
    MemtoRegE => s_MemtoRegE,
    MemtoRegM => s_MemtoRegM,
    RsD => s_RsD,
    RtD => s_RtD,
    RsE => s_RsE,
    RtE => s_RtE,
    WriteRegE => s_WriteRegE,
    WriteRegM => s_WriteRegM,
    WriteRegW => s_WriteRegW,
    -- to controller
    EqualD => s_EqualD,
    Op => s_Op,
    Funct => s_Funct,
    -- to Data memory
    MemWriteM => memwrite,
    ALUOutM => aluout,
    WriteDataM => writedata
  );

  hu: hazard_unit
  port map (
    clock => clk,
    RsD => s_RsD,
    RtD => s_RtD,
    RsE => s_RsE,
    RtE => s_RtE,
    BranchD => s_BranchD,
    WriteRegE => s_WriteRegE,
    MemtoRegE => s_MemtoRegE,
    RegWriteE => s_RegWriteE,
    WriteRegM => s_WriteRegM,
    MemtoRegM => s_MemtoRegM,
    RegWriteM => s_RegWriteM,
    WriteRegW => s_WriteRegW,
    RegWriteW => s_RegWriteW,
    StallF => s_StallF,
    StallD => s_StallD,
    ForwardAD => s_ForwardAD,
    ForwardBD => s_ForwardBD,
    FlushE => s_FlushE,
    ForwardAE => s_ForwardAE,
    ForwardBE => s_ForwardBE
  );
end;
