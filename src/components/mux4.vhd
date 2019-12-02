----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 30/11/2019       
-- Arquivo : mux4.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Mutliplexidador de quatro entradas
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity mux4 is
  generic (
    width: integer
  );
  port (
    d0, d1, d2, d3: in  std_logic_vector(width-1 downto 0);
    s:      in  std_logic_vector(1 downto 0);
    y:      out std_logic_vector(width-1 downto 0)
  );
end;

architecture behave of mux4 is
begin
  with s select
    y <= d0 when "00",
         d1 when "01",
         d2 when "10",
         d3 when "11",
         (others => '0') when others;
end;
