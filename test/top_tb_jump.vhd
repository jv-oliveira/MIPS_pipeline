----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 01/12/2019       
-- Arquivo : top_tb_jump.vhd                                             
----------------------------------------------------------------------
-- Descrição : Testbench do MIPS para o jump
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; use IEEE.numeric_std_unsigned.all;

entity top_tb_jump is
end top_tb_jump;

architecture test of top_tb_jump is

  signal writedata, dataadr:    std_logic_vector(31 downto 0);
  signal clk, reset,  memwrite: std_logic;


  component top
    port (
      clk, reset:           in  std_logic;
      writedata, dataadr:   out std_logic_vector(31 downto 0);
      memwrite:             out std_logic
    );
  end component;
  
begin

  -- instantiate device to be tested
  dut: top port map(clk, reset, writedata, dataadr, memwrite);

  -- Generate clock with 10 ns period
  process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Generate reset for first two clock cycles
  process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;

  -- check that 7 gets written to address 84 at end of program
  process (clk) 
  begin
    if falling_edge(clk) then
      if memwrite = '1' then
        if (to_integer(dataadr) = 84 and to_integer(writedata) = 7) then
          report "NO ERRORS: Simulation succeeded" severity note;
          std.env.stop;
        elsif (to_integer(dataadr) /= 80) then
          report "Simulation failed" severity failure;
        end if;
      end if ;
    end if;
  end process;
end;
