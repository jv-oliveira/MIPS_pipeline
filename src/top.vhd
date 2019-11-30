----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : top.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Entidade de N�vel mais alto para realiza��o de testes
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; use IEEE.numeric_std.all;

entity top is -- top-level design for testing
  port (
    clk, reset:           in     std_logic;
    writedata, dataadr:   buffer std_logic_vector(31 downto 0);
    memwrite:             buffer std_logic
  );
end;

architecture test of top is
  component mips
    port (
      clk, reset:        in  std_logic;
      pc:                out std_logic_vector(31 downto 0);
      instr:             in  std_logic_vector(31 downto 0);
      memwrite:          out std_logic;
      aluout, writedata: out std_logic_vector(31 downto 0);
      readdata:          in  std_logic_vector(31 downto 0));
  end component;

  component imem
    port (
      a:  in  std_logic_vector(5 downto 0);
      rd: out std_logic_vector(31 downto 0)
    );
  end component;

  component dmem
    port (
      clk, we:  in std_logic;
      a, wd:    in std_logic_vector(31 downto 0);
      rd:       out std_logic_vector(31 downto 0)
    );
  end component;

  signal pc, instr, readdata: std_logic_vector(31 downto 0);
begin
  -- instantiate processor and memories
  mips1: mips port map(clk, reset, pc, instr, memwrite, dataadr,
                       writedata, readdata);
  imem1: imem port map(pc(7 downto 2), instr);
  dmem1: dmem port map(clk, memwrite, dataadr, writedata, readdata);
end;
