----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : sl2.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Deslocador � esquerda de 2 de uma palavra de 32 bits
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity sl2 is
  port (
    a: in  std_logic_vector(31 downto 0);
    y: out std_logic_vector(31 downto 0)
  );
end;

architecture behave of sl2 is
begin
  y <= a(29 downto 0) & "00";
end;
