----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 29/11/2019       
-- Arquivo : regE.vhd                                             
----------------------------------------------------------------------
-- Descrição : registrador de pipeline da etapa de Execução
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std_unsigned.all;

entity regE is  
  port (
    clk:        in  std_logic;
    clr:        in  std_logic;
    en:         in  std_logic;
    RegWriteD:  in  std_logic;
    MemtoRegD:  in  std_logic;
    MemWriteD:  in  std_logic;
    ALUControlD:in  std_logic_vector(2 downto 0);
    ALUSrcD:    in  std_logic;
    RegDstD:    in  std_logic;
    RD1D:       in  std_logic_vector(31 downto 0);
    RD2D:       in  std_logic_vector(31 downto 0);
    RsD:        in  std_logic_vector(4 downto 0);
    RtD:        in  std_logic_vector(4 downto 0);
    RdD:        in  std_logic_vector(4 downto 0);
    RegWriteE:  out std_logic;
    MemtoRegE:  out std_logic;
    MemWriteE:  out std_logic;
    ALUControlE:out std_logic_vector(2 downto 0);
    ALUSrcE:    out std_logic;
    RegDstE:    out std_logic;
    RD1E:       out std_logic_vector(31 downto 0);
    RD2E:       out std_logic_vector(31 downto 0);
    RsE:        out std_logic_vector(4 downto 0);
    RtE:        out std_logic_vector(4 downto 0);
    RdE:        out std_logic_vector(4 downto 0)
  );
end regE ;

architecture bhv of regE is
begin
  process( all )
  begin
    if clr = '1' then
      RegWriteE <= '0';
      MemtoRegE <= '0';
      MemWriteE <= '0';
      ALUControlE <= (others => '0');
      ALUSrcE <= '0';
      RegDstE <= '0';
      RD1E <= (others => '0');
      RD2E <= (others => '0');
      RsE <= (others => '0');
      RtE <= (others => '0');
      RdE <= (others => '0');
    elsif rising_edge(clk)  then
      if en = '1' then
        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoRegD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RegDstE <= RegDstD;
        RD1E <= RD1D;
        RD2E <= RD2D;
        RsE <= RsD;
        RtE <= RtD;
        RdE <= RdD;
      end if;
    end if ;
  end process ;
end architecture ; -- bhv
