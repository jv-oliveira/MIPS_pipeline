----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 29/11/2019       
-- Arquivo : regM.vhd                                             
----------------------------------------------------------------------
-- Descri��o : registrador de pipeline da etapa de Mem�ria
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regM is
  port (
    clk:        in  std_logic;
    clr:        in  std_logic;
    en:         in  std_logic;
    RegWriteE:  in  std_logic;
    MemtoRegE:  in  std_logic;
    MemWriteE:  in  std_logic;
    ALUOutE:    in  std_logic_vector(31 downto 0);
    WriteDataE: in  std_logic_vector(31 downto 0);
    WriteRegE:  in  std_logic_vector(4 downto 0);
    RegWriteM:  out std_logic;
    MemtoRegM:  out std_logic;
    MemWriteM:  out std_logic;
    ALUOutM:    out std_logic_vector(31 downto 0);
    WriteDataM: out std_logic_vector(31 downto 0);
    WriteRegM:  out std_logic_vector(4 downto 0)
  );
end regM ;

architecture bhv of regM is
begin
  process( all )
  begin
    if rising_edge(clk)  then
      if clr = '1' then
        RegWriteM <= '0';
        MemtoRegM <= '0';
        MemWriteM <= '0';
        ALUOutM <= (others => '0');
        WriteDataM <= (others => '0');
        WriteRegM <= (others => '0');
      elsif en = '1' then
        RegWriteM <= RegWriteE;
        MemtoRegM <= MemtoRegE;
        MemWriteM <= MemWriteE;
        ALUOutM <= ALUOutE;
        WriteDataM <= WriteDataE;
        WriteRegM <= WriteRegE;
      end if;
    end if ;
  end process ;
end architecture ; -- bhv
