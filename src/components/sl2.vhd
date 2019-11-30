----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : sl2.vhd                                             
----------------------------------------------------------------------
-- Descrição : Deslocador à esquerda de 2 de uma palavra de 32 bits
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
