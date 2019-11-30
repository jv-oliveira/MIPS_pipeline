----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 29/11/2019       
-- Arquivo : regW.vhd                                             
----------------------------------------------------------------------
-- Descri��o : registrador de pipeline da etapa de Write Back
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regW is
  port (
    clk:        in  std_logic;
    clr:        in  std_logic;
    en:         in  std_logic;
    RegWriteM:  in  std_logic;
    MemtoRegM:  in  std_logic;
    ReadDataM:  in  std_logic_vector(31 downto 0);
    ALUOutM:    in  std_logic_vector(31 downto 0);
    WriteRegM:  in  std_logic_vector(4 downto 0);
    RegWriteW:  out std_logic;
    MemtoRegW:  out std_logic;
    ReadDataW:  out std_logic_vector(31 downto 0);
    ALUOutW:    out std_logic_vector(31 downto 0);
    WriteRegW:  out std_logic_vector(4 downto 0)
  );
end regW ;

architecture bhv of regW is
begin
  process( all )
    if clr = '1' then
      RegWriteW <= '0';
      MemtoRegW <= '0';
      ReadDataW <= (others => '0');
      ALUOutW <= (others => '0');
      WriteRegW <= (others => '0');
    elsif rising_edge(clk)  then
      if en = '1' then
        RegWriteW <= RegWriteM;
        MemtoRegW <= MemtoRegM;
        ReadDataW <= ReadDataM;
        ALUOutW <= ALUOutM;
        WriteRegW <= WriteRegM;
      end if;
    end if ;
  end process ;
end architecture ; -- bhv
