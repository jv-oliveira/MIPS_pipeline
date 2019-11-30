----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 29/11/2019       
-- Arquivo : regF.vhd                                             
----------------------------------------------------------------------
-- Descri��o : registrador de pipeline da etapa de Fetch
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regF is
  port (
    clk:        in  std_logic;
    clr:        in  std_logic;
    en:         in  std_logic;
    PC:         in  std_logic_vector(31 downto 0);
    PCF:        out std_logic_vector(31 downto 0)
  );
end regF ;

architecture bhv of regF is

begin
  process( all )
    if clr = '1' then
      PCF <= (others => '0');
    elsif rising_edge(clk)  then
      if en = '1' then
        PCF <= PC;
      end if;
    end if ;
  end process ;
end architecture ; -- bhv
