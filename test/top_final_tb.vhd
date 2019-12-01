----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 01/12/2019       
-- Arquivo : top_final_tb.vhd                                             
----------------------------------------------------------------------
-- Descri��o : testbench final para o mips
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; use IEEE.numeric_std_unsigned.all;

entity top_final_tb is
end top_final_tb;

architecture test of top_final_tb is

  signal writedata, dataadr:    std_logic_vector(31 downto 0);
  signal clk, reset,  memwrite: std_logic;


  component top
    generic (
      filename : string := "memfile.dat"
    );
    port (
      clk, reset:           in  std_logic;
      writedata, dataadr:   out std_logic_vector(31 downto 0);
      memwrite:             out std_logic
    );
  end component;
  
begin

  -- instantiate device to be tested
  dut: top 
  generic map("top_final_tb.dat")
  port map(clk, reset, writedata, dataadr, memwrite);

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
    variable clk_count: integer := 0;
  begin
    if falling_edge(clk) then
      clk_count := clk_count + 1;
      if memwrite = '1' then
        if (to_integer(dataadr) = 84 and writedata = X"ffff7f02") then
          report "NO ERRORS: Simulation succeeded" severity note;
          std.env.stop;
        end if;
      end if;
      if clk_count >= 1000 then
        report "Simulation failed, testbench took too long!" severity failure;
      end if;
    end if;
  end process;
end;
