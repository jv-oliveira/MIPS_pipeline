----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : mux2.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Mutliplexidador de duas entradas
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
