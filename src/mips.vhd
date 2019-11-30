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

entity mips is -- single cycle MIPS processor
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
  
  component datapath
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
      RsD, RtD, RsE, RtE:out std_logic_vector(31 downto 0);
      WriteRegE, WriteRegM, WriteRegW: out std_logic_vector(4 downto 0);
      readdata:          in  std_logic_vector(31 downto 0)
    );
  end component;

  signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc: std_logic;
  signal zero: std_logic;
  signal alucontrol: std_logic_vector(2 downto 0);

  signal s_WriteRegM, s_WriteRegW, s_WriteRegE: std_logic_vector(4 downto 0);
  signal s_RsD, s_RtD, s_RsE, s_RtE: std_logic_vector(31 downto 0);

begin
  cont: controller 
  port map (
    instr(31 downto 26),
    instr(5 downto 0),
    zero,
    memtoreg,
    memwrite,
    pcsrc,
    alusrc,
    regdst,
    regwrite,
    jump,
    alucontrol
  );

  dp: datapath 
  port map (
    clk,
    reset, 
    memtoreg, 
    pcsrc, 
    alusrc, 
    regdst,
    regwrite, 
    jump, 
    alucontrol, 
    zero, 
    pc, 
    instr,
    aluout, 
    writedata,
    s_RsD,
    s_RtD,
    s_RsE,
    s_RtE,
    s_WriteRegE,
    s_WriteRegM,
    s_WriteRegW,
    readdata
  );
end;
