----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : dmem.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Mem�ria de Dados do MIPS
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; use STD.TEXTIO.all;
use IEEE.numeric_std.all;

entity dmem is -- data memory
  port (
    clk, we:  in std_logic;
    a, wd:    in std_logic_vector(31 downto 0);
    rd:       out std_logic_vector(31 downto 0)
  );
end;

architecture behave of dmem is
begin
  process is
    type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);
    variable mem: ramtype;
  begin
    -- read or write memory
    loop
      if clk'event and clk = '1' then
          if (we = '1') then mem(to_integer(unsigned(a(7 downto 2)))) := wd;
          end if;
      end if;
      rd <= mem(to_integer(unsigned(a(7 downto 2))));
      wait on clk, a;
    end loop;
  end process;
end;
