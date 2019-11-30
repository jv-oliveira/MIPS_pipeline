----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : top.vhd                                             
----------------------------------------------------------------------
-- Descrição : Entidade de Nível mais alto para realização de testes
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
