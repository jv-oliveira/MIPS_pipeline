----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 29/11/2019       
-- Arquivo : regD.vhd                                             
----------------------------------------------------------------------
-- Descrição : registrador de pipeline da etapa de Decode
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regD is
  port (
    clk:        in  std_logic;
    clr:        in  std_logic;
    en:         in  std_logic;
    InstrF:     in  std_logic_vector(31 downto 0);
    PCplus4F:   in  std_logic_vector(31 downto 0);
    InstrD:     out std_logic_vector(31 downto 0);
    PCPlus4D:   out std_logic_vector(31 downto 0)
  );
end regD ;

architecture bhv of regD is
begin
  process( all )
  begin
    if clr = '1' then
      InstrD <= (others => '0');
      PCPlus4D <= (others => '0');
    elsif rising_edge(clk)  then
      if en = '1' then
        InstrD <= InstrF;
        PCPlus4D <= PCplus4F;
      end if;
    end if ;
  end process ;
end architecture ; -- bhv
