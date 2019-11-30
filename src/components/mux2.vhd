----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : mux2.vhd                                             
----------------------------------------------------------------------
-- Descrição : Mutliplexidador de duas entradas
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity mux2 is
  generic (
    width: integer
  );
  port (
    d0, d1: in  std_logic_vector(width-1 downto 0);
    s:      in  std_logic;
    y:      out std_logic_vector(width-1 downto 0)
  );
end;

architecture behave of mux2 is
begin
  y <= d1 when s else d0;
end;
