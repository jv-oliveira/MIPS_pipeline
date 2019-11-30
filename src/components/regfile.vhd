----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : regfile.vhd                                             
----------------------------------------------------------------------
-- Descrição : Banco de 32 registradores de 32 bits. 
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is -- three-port register file
  port (
    clk:           in  std_logic;
    we3:           in  std_logic;
    ra1, ra2, wa3: in  std_logic_vector(4 downto 0);
    wd3:           in  std_logic_vector(31 downto 0);
    rd1, rd2:      out std_logic_vector(31 downto 0)
  );
end;

architecture behave of regfile is
  type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal mem: ramtype;
begin
  -- three-ported register file
  -- read two ports combinationally
  -- write third port on rising edge of clock
  -- register 0 hardwired to 0
  -- note: for pipelined processor, write third port
  -- on falling edge of clk
  process(clk) begin
    if rising_edge(clk) then
       if we3 = '1' then mem(to_integer(unsigned(wa3))) <= wd3;
       end if;
    end if;
  end process;
  process(all) begin
    if (to_integer(unsigned(ra1)) = 0) then rd1 <= X"00000000"; -- register 0 holds 0
    else rd1 <= mem(to_integer(unsigned(ra1)));
    end if;
    if (to_integer(unsigned(ra2)) = 0) then rd2 <= X"00000000";
    else rd2 <= mem(to_integer(unsigned(ra2)));
    end if;
  end process;
end;
