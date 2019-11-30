----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : flopr.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Flip-flop com reset s�ncrono
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;  use IEEE.std_logic_ARITH.all;

entity flopr is
  generic (
    width: integer
  );
  port (
    clk, reset: in  std_logic;
    d:          in  std_logic_vector(width-1 downto 0);
    q:          out std_logic_vector(width-1 downto 0)
  );
end;

architecture asynchronous of flopr is
begin
  process(clk, reset) begin
    if reset then  q <= (others => '0');
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;
end;
