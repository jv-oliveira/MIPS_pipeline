----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : adder.vhd                                             
----------------------------------------------------------------------
-- Descrição : Somador de duas palavras de 32 bits
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity adder is -- adder
  port (
    a, b: in  std_logic_vector(31 downto 0);
    y:    out std_logic_vector(31 downto 0)
  );
end;

architecture behave of adder is
begin
  y <= a + b;
end;
