----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 30/11/2019       
-- Arquivo : registrador_n.vhd                                             
----------------------------------------------------------------------
-- Descrição : registrador genérico
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_n is
  generic (
       constant N: integer := 8 
  );
  port (
    clk, clr, en: in std_logic;
    D:            in   std_logic_vector(N-1 downto 0);
    Q:            out  std_logic_vector (N-1 downto 0)
  );
end reg_n;

architecture registrador_n of reg_n is
  signal IQ: std_logic_vector(N-1 downto 0);
begin
  process(all)
    begin
      if (clr = '1') then
        IQ <= (others => '0');
      elsif rising_edge(clk) then
        if en = '1' then 
          IQ <= D; 
        end if;
      end if;
      Q <= IQ;
  end process;  
end registrador_n;
