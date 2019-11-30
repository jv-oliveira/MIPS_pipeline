----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 29/11/2019       
-- Arquivo : regD.vhd                                             
----------------------------------------------------------------------
-- Descri��o : registrador de pipeline da etapa de Decode
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
