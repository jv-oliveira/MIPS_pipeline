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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is  -- MIPS datapath
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
    PCSrcD:       in std_logic_vector(1 downto 0);
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
    EqualD:   out  std_logic;
    Op, Funct: out  std_logic_vector(5 downto 0);
    -- to Data memory
    MemWriteM:  out std_logic;
    ALUOutM:    out std_logic_vector(31 downto 0);
    WriteDataM: out std_logic_vector(31 downto 0)
  );
end;

architecture struct of datapath is

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

  component regD is
    port (
      clk:        in  std_logic;
      clr:        in  std_logic;
      en:         in  std_logic;
      InstrF:     in  std_logic_vector(31 downto 0);
      PCplus4F:   in  std_logic_vector(31 downto 0);
      InstrD:     out std_logic_vector(31 downto 0);
      PCPlus4D:   out std_logic_vector(31 downto 0)
    );
  end component;

  component regE is  
    port (
      clk:        in  std_logic;
      clr:        in  std_logic;
      en:         in  std_logic;
      RegWriteD:  in  std_logic;
      MemtoRegD:  in  std_logic;
      MemWriteD:  in  std_logic;
      ALUControlD:in  std_logic_vector(2 downto 0);
      ALUSrcD:    in  std_logic;
      RegDstD:    in  std_logic;
      RD1D:       in  std_logic_vector(31 downto 0);
      RD2D:       in  std_logic_vector(31 downto 0);
      RsD:        in  std_logic_vector(4 downto 0);
      RtD:        in  std_logic_vector(4 downto 0);
      RdD:        in  std_logic_vector(4 downto 0);
      SignImmD:   in  std_logic_vector(31 downto 0);
      RegWriteE:  out std_logic;
      MemtoRegE:  out std_logic;
      MemWriteE:  out std_logic;
      ALUControlE:out std_logic_vector(2 downto 0);
      ALUSrcE:    out std_logic;
      RegDstE:    out std_logic;
      RD1E:       out std_logic_vector(31 downto 0);
      RD2E:       out std_logic_vector(31 downto 0);
      RsE:        out std_logic_vector(4 downto 0);
      RtE:        out std_logic_vector(4 downto 0);
      RdE:        out std_logic_vector(4 downto 0);
      SignImmE:   out std_logic_vector(31 downto 0)
    );
  end component;

  component regM is
    port (
      clk:        in  std_logic;
      clr:        in  std_logic;
      en:         in  std_logic;
      RegWriteE:  in  std_logic;
      MemtoRegE:  in  std_logic;
      MemWriteE:  in  std_logic;
      ALUOutE:    in  std_logic_vector(31 downto 0);
      WriteDataE: in  std_logic_vector(31 downto 0);
      WriteRegE:  in  std_logic_vector(4 downto 0);
      RegWriteM:  out std_logic;
      MemtoRegM:  out std_logic;
      MemWriteM:  out std_logic;
      ALUOutM:    out std_logic_vector(31 downto 0);
      WriteDataM: out std_logic_vector(31 downto 0);
      WriteRegM:  out std_logic_vector(4 downto 0)
    );
  end component;

  component regW is
    port (
      clk:        in  std_logic;
      clr:        in  std_logic;
      en:         in  std_logic;
      RegWriteM:  in  std_logic;
      MemtoRegM:  in  std_logic;
      ReadDataM:  in  std_logic_vector(31 downto 0);
      ALUOutM:    in  std_logic_vector(31 downto 0);
      WriteRegM:  in  std_logic_vector(4 downto 0);
      RegWriteW:  out std_logic;
      MemtoRegW:  out std_logic;
      ReadDataW:  out std_logic_vector(31 downto 0);
      ALUOutW:    out std_logic_vector(31 downto 0);
      WriteRegW:  out std_logic_vector(4 downto 0)
    );
  end component;

  component reg_n is
    generic (
         constant N: integer := 8 
    );
    port (
      clk, clr, en: in std_logic;
      D:            in   std_logic_vector(N-1 downto 0);
      Q:            out  std_logic_vector (N-1 downto 0)
    );
  end component;

  component  mux4 is
    generic (
      width: integer
    );
    port (
      d0, d1, d2, d3: in  std_logic_vector(width-1 downto 0);
      s:      in  std_logic_vector(1 downto 0);
      y:      out std_logic_vector(width-1 downto 0)
    );
  end component;

  constant NEXT_PC_STEP: std_logic_vector(31 downto 0) := X"00000004";

  -- pipeline signals related to Control Unit
  signal s_RegWriteD  ,   s_RegWriteE   , s_RegWriteM , s_RegWriteW : std_logic := '0';
  signal s_MemtoRegD  ,   s_MemtoRegE   , s_MemtoRegM , s_MemtoRegW : std_logic := '0';
  signal s_MemWriteD  ,   s_MemWriteE   , s_MemWriteM               : std_logic := '0';
  signal s_BranchD    ,   s_BranchE     , s_BranchM                 : std_logic := '0';
  signal s_ALUControlD,   s_ALUControlE                             : std_logic_vector(2 downto 0) := (others => '0');
  signal s_ALUSrcD    ,   s_ALUSrcE                                 : std_logic := '0';
  signal s_RegDstD    ,   s_RegDstE                                 : std_logic := '0';
  signal s_PCSrcM                                                   : std_logic := '0';


  -- pipeline signals related to Hazard Unit
  signal s_StallF, s_StallD: std_logic := '0';
  signal s_ForwardAD, s_ForwardBD: std_logic := '0';
  signal s_FlushE: std_logic := '0';
  signal s_ForwardAE, s_ForwardBE: std_logic_vector(1 downto 0) := (others => '0');
  signal s_RsD, s_RtD, s_RdD, s_RdE: std_logic_vector(4 downto 0) := (others => '0');
  signal s_RsE, s_RtE: std_logic_vector(4 downto 0) := (others => '0');
  
  signal s_PCSrcD: std_logic_vector(1 downto 0) := (others => '0');

  signal s_SignImmD, s_SignImmDsh, s_SignImmE: std_logic_vector(31 downto 0) := (others => '0');

  signal s_ALUOutE, s_ALUOutM, s_ALUOutW, s_ResultW, s_SrcAE, s_SrcBE: std_logic_vector(31 downto 0) := (others => '0');

  signal s_RD1, s_RD2, s_RD1D, s_RD2D, s_RD1E, s_RD2E: std_logic_vector(31 downto 0) := (others => '0');

  signal s_WriteRegE, s_WriteRegM, s_WriteRegW: std_logic_vector(4 downto 0) := (others => '0');

  signal s_WriteDataE, s_WriteDataM: std_logic_vector(31 downto 0) := (others => '0');

  signal s_PCNext, s_PCPlus4F, s_PCPlus4D,
         s_PCPlus4E, s_PCBranchD, s_PCF, s_PCJump: std_logic_vector(31 downto 0) := (others => '0');

  signal s_InstrF, s_InstrD: std_logic_vector(31 downto 0) := (others => '0');

  signal s_ReadDataM, s_ReadDataW: std_logic_vector(31 downto 0) := (others => '0');

  signal pcreg_en, regD_en, clk_regfile: std_logic;

  signal regD_clr, regE_clr, regM_clr, regW_clr: std_logic;

begin
  -- ############
  -- INPUTS
  -- ############

  -- from instruction memory
  s_InstrF <= InstrF;
  -- from data memory
  s_ReadDataM <= ReadDataM;
  -- from controller
  s_RegWriteD <= RegWriteD;
  s_MemtoRegD <= MemtoRegD;
  s_MemWriteD <= MemWriteD;  
  s_ALUControlD <= ALUControlD;
  s_ALUSrcD <= ALUSrcD;
  s_RegDstD <= RegDstD;
  s_PCSrcD <= PCSrcD;
  -- from hazard units
  s_StallF <= StallF;
  s_StallD <= StallD;
  s_ForwardAD <= ForwardAD;
  s_ForwardBD <= ForwardBD;
  s_FlushE <=  FlushE;
  s_ForwardAE <=  ForwardAE;
  s_ForwardBE <=  ForwardBE;

  -- ############
  -- OUTPUTS
  -- ############

  -- to instruction memory
  PCF <= s_PCF;
  -- to hazard unit
  RegWriteE <= s_RegWriteE;
  RegWriteM <= s_RegWriteM;
  RegWriteW <= s_RegWriteW;
  MemtoRegE <= s_MemtoRegE;
  MemtoRegM <= s_MemtoRegM;
  RsD <= s_RsD;
  RtD <= s_RtD;
  RsE <= s_RsE;
  RtE <= s_RtE;
  WriteRegE <= s_WriteRegE;
  WriteRegM <= s_WriteRegM;
  WriteRegW <= s_WriteRegW;
  -- to controller
  EqualD <= '1' when s_RD1D = s_RD2D else '0';
  Op <= s_InstrD(31 downto 26);
  Funct <= s_InstrD(5 downto 0);
  -- to Data memory
  MemWriteM <= s_MemWriteM;
  ALUOutM <= s_ALUOutM;
  WriteDataM <= s_WriteDataM;
  

  -- ############
  -- FETCH
  -- ############

  -- add 4, advancinf pc
  s_PCPlus4F <= std_logic_vector(unsigned(s_PCF) + unsigned(NEXT_PC_STEP));

  s_PCJump <= s_PCF(31 downto 28) & s_instrD(25 downto 0) & "00";

  pcnextmux: mux4
  generic map(32)
  port map (
    s_PCPlus4F,
    s_PCBranchD,
    s_PCJump,
    X"00000000",
    s_PCSrcD,
    s_PCNext
  );
  
  pcreg_en <= not s_StallF;
  pcreg: reg_n 
  generic map(32) 
  port map (
    clk, 
    reset,
    pcreg_en, 
    s_PCnext, 
    s_PCF
  );

  -- ############
  -- IF/ID reg
  -- ############

  regD_clr <= s_PCSrcD(0) or reset;
  regD_en <= not s_StallD;
  REG_IF_ID: regD
  port map (
    clk => clk,
    clr => regD_clr,
    en => regD_en,
    InstrF => s_InstrF,
    PCplus4F => s_PCplus4F,
    InstrD => s_InstrD,
    PCPlus4D => s_PCPlus4D
  );

  -- ############
  -- DECODE
  -- ############

  -- register file logic
  clk_regfile <= not clk;
  rf: regfile 
  port map (
    clk_regfile,
    s_RegWriteW,
    s_InstrD(25 downto 21),
    s_InstrD(20 downto 16),
    s_WriteRegW,
    s_ResultW,
    s_RD1,
    s_RD2
  );

  s_RsD <= s_InstrD(25 downto 21);
  s_RtD <= s_InstrD(20 downto 16);
  s_RdD <= s_InstrD(15 downto 11);

  s_RD1D <= s_RD1 when s_ForwardAD = '0' else s_ALUOutM;
  s_RD2D <= s_RD2 when s_ForwardBD = '0' else s_ALUOutM;
  

  -- signal extender
  s_SignImmD <= X"ffff" & s_InstrD(15 downto 0) when s_InstrD(15) else X"0000" & s_InstrD(15 downto 0);

  s_SignImmDsh <= s_SignImmD(29 downto 0) & "00";

  s_PCBranchD <= std_logic_vector(unsigned(s_PCPlus4D) + unsigned(s_SignImmDsh));  

  -- ############
  -- ID/EX reg
  -- ############
  regE_clr <= s_FlushE or reset;
  REG_ID_EX: regE
  port map (
    clk => clk,
    clr => regE_clr,
    en => '1',
    RegWriteD => s_RegWriteD,
    MemtoRegD => s_MemtoRegD,
    MemWriteD => s_MemWriteD,
    ALUControlD => s_ALUControlD,
    ALUSrcD => s_ALUSrcD,
    RegDstD => s_RegDstD,
    RD1D => s_RD1D,
    RD2D => s_RD2D,
    RsD => s_RsD,
    RtD => s_RtD,
    RdD => s_RdD,
    SignImmD => s_SignImmD,
    RegWriteE => s_RegWriteE,
    MemtoRegE => s_MemtoRegE,
    MemWriteE => s_MemWriteE,
    ALUControlE => s_ALUControlE,
    ALUSrcE => s_ALUSrcE,
    RegDstE => s_RegDstE,
    RD1E => s_RD1E,
    RD2E => s_RD2E,
    RsE => s_RsE,
    RtE => s_RtE,
    RdE => s_RdE,
    SignImmE => s_SignImmE
  );

  -- ############
  -- EXECUTION
  -- ############

  srcAmux: mux4
  generic map(32)
  port map (
    s_RD1E,
    s_ResultW,
    s_ALUOutM,
    X"00000000",
    s_ForwardAE,
    s_SrcAE
  );

  wdEmux: mux4
  generic map(32)
  port map (
    s_RD2E,
    s_ResultW,
    s_ALUOutM,
    X"00000000",
    s_ForwardBE,
    s_WriteDataE
  );

  s_SrcBE <= s_WriteDataE when s_ALUSrcE = '0' else s_SignImmE;

  mainalu: alu 
  port map (
    s_SrcAE, 
    s_SrcBE, 
    s_ALUControlE, 
    s_ALUOutE, 
    open -- TODO verificar isso aqui
  );

  s_WriteRegE <= s_RtE when s_RegDstE = '0' else s_RdE;

  -- hazard unit signals
  RsE <= s_RsE;
  RtE <= s_RtE;
  WriteRegE <= s_WriteRegE;

  -- ############
  -- EX/MEM reg
  -- ############
  regM_clr <= reset;
  REG_EX_MEM: regM
  port map (
    clk => clk,
    clr => regM_clr,
    en => '1',
    RegWriteE => s_RegWriteE,
    MemtoRegE => s_MemtoRegE,
    MemWriteE => s_MemWriteE,
    ALUOutE => s_ALUOutE,
    WriteDataE => s_WriteDataE,
    WriteRegE => s_WriteRegE,
    RegWriteM => s_RegWriteM,
    MemtoRegM => s_MemtoRegM,
    MemWriteM => s_MemWriteM,
    ALUOutM => s_ALUOutM,
    WriteDataM => s_WriteDataM,
    WriteRegM => s_WriteRegM
  );

  -- ############
  -- MEMORY
  -- ############

  -- hazard unit signal
  WriteRegM <= s_WriteRegM;

  -- MEM/WB reg
  regW_clr <= reset;
  REG_MEM_WB: regW
  port map (
    clk => clk,
    clr => regW_clr,
    en => '1',
    RegWriteM => s_RegWriteM,
    MemtoRegM => s_MemtoRegM,
    ReadDataM => s_ReadDataM,
    ALUOutM => s_ALUOutM,
    WriteRegM => s_WriteRegM,
    RegWriteW => s_RegWriteW,
    MemtoRegW => s_MemtoRegW,
    ReadDataW => s_ReadDataW,
    ALUOutW => s_ALUOutW,
    WriteRegW => s_WriteRegW
  );

  -- ############
  -- WRITE BACK
  -- ############

  s_ResultW <= s_ReadDataW when s_MemtoRegW = '1' else s_ALUOutW;

  -- hazard unit signal
  WriteRegW <= s_WriteRegW;

end;
