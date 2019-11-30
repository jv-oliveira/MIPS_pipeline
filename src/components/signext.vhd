----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : signext.vhd                                             
----------------------------------------------------------------------
-- Descrição : Extensor de sinal de 16 bits para 32 bits, leva em
--             consideração o sinal
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity signext is
  port (
    a: in  std_logic_vector(15 downto 0);
    y: out std_logic_vector(31 downto 0)
  );
end;

architecture behave of signext is
begin
  y <= X"ffff" & a when a(15) else X"0000" & a;
end;
