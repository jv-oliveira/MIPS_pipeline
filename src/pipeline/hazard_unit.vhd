----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 29/11/2019       
-- Arquivo : hazard_unit.vhd                                             
----------------------------------------------------------------------
-- Descrição : unidade de detecção de conflito do pipeline do MIPS
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazard_unit is
  port (
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
end hazard_unit ;

architecture bhv of hazard_unit is

  signal s_lwstall: std_logic;
  signal s_branchstall: std_logic;
  signal s_branchstallE, s_branchstallM: std_logic;

begin

  FOWARDING_A : process( all )
  begin
    if ((RsE /= "00000") and (RsE = WriteRegM) and (RegWriteM = '1')) then
      ForwardAE <= "10";
    elsif ((RsE /= "00000") and (RsE = WriteRegW) and (RegWriteW = '1')) then
      ForwardAE <= "01";
    else 
      ForwardAE <= "00";
    end if ;
  end process ; -- FOWARDING_A

  FOWARDING_B : process( all )
  begin
    if ((RtE /= "00000") and (RtE = WriteRegM) and (RegWriteW = '1')) then
      ForwardBE <= "10";
    elsif ((RtE /= "00000") and (RtE = WriteRegW) and (RegWriteW = '1')) then
      ForwardBE <= "01";
    else 
      ForwardBE <= "00";
    end if ;
  end process ; -- FOWARDING_B

  -- STALLS
  s_lwstall <= '1' when (((RsD = RtE) or (RtD = RtE)) and (MemtoRegE = '1')) else '0';

  s_branchstallE <= '1' when ((BranchD = '1') and (RegWriteE = '1') and ((WriteRegE = RsD) or (WriteRegE = RtD))) else '0';
  s_branchstallM <= '1' when ((BranchD = '1') and (MemtoRegM = '1') and ((WriteRegM = RsD) or (WriteRegM = RtD))) else '0';
  s_branchstall <= s_branchstallE or s_branchstallM;

  StallF <= s_lwstall or s_branchstall;
  StallD <= s_lwstall or s_branchstall;
  FlushE <= s_lwstall or s_branchstall;

  -- CONTROL HAZARDS
  ForwardAD <= '1' when ((RsD /= "00000") and (RsD = WriteRegM) and (RegWriteM = '1')) else '0';
  ForwardBD <= '1' when ((RtD /= "00000") and (RtD = WriteRegM) and (RegWriteM = '1')) else '0';
  
end architecture ; -- bhv
