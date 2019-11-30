----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
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

entity hazard_unit is
  port (
    clock:      in  std_logic;
    RsD:        in  std_logic_vector(4 downto 0);
    RtD:        in  std_logic_vector(4 downto 0);
    RsE:        in  std_logic_vector(4 downto 0);
    RtE:        in  std_logic_vector(4 downto 0);
    WriteRegE:  in  std_logic_vector(4 downto 0);
    WriteRegM:  in  std_logic_vector(4 downto 0);
    WriteRegW:  in  std_logic_vector(4 downto 0);
    StallF:     out std_logic;
    StallD:     out std_logic;
    BranchD:    out std_logic;
    ForwardAD:  out std_logic;
    ForwardBD:  out std_logic;
    FlushE:     out std_logic;
    ForwardAE:  out std_logic;
    ForwardBE:  out std_logic;
    MemtoRegE:  out std_logic;
    RegWriteE:  out std_logic;
    MemtoRegM:  out std_logic;
    RegWriteM:  out std_logic;
    RegWriteW:  out std_logic
  );
end hazard_unit ;

architecture bhv of hazard_unit is

begin
end architecture ; -- bhv
