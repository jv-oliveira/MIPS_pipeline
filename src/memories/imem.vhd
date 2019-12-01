----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : imem.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Mem�ria de instru��o do MIPS
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; use STD.TEXTIO.all;
use ieee.numeric_std.all;

entity imem is -- instruction memory
  generic (
    filename : string := "memfile.dat"
  );
  port (
    a:  in  std_logic_vector(5 downto 0);
    rd: out std_logic_vector(31 downto 0)
  );
end;

architecture behave of imem is
begin
  process is
    file mem_file: TEXT;
    variable L: line;
    variable ch: character;
    variable i, index, result: integer;
    type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);
    variable mem: ramtype;
  begin
    -- initialize memory from file
    for i in 0 to 63 loop -- set all contents low
      mem(i) := (others => '0');
    end loop;
    index := 0;
    FILE_OPEN(mem_file, filename, READ_MODE);
    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then
            result := character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
           result := character'pos(ch) - character'pos('a')+10;
        else report "Format error on line " & integer'image(index)
             severity failure;
        end if;
        mem(index)(35-i*4 downto 32-i*4) := std_logic_vector(to_unsigned(result, 4));
      end loop;
      index := index + 1;
    end loop;

    -- read memory
    loop
      rd <= mem(to_integer(unsigned(a)));
      wait on a;
    end loop;
  end process;
end;
