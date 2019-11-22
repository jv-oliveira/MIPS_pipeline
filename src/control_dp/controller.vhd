----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : controller.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Unidade de Controle do MIPS
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity controller is -- single cycle control decoder
  port (
    op, funct:          in  std_logic_vector(5 downto 0);
    zero:               in  std_logic;
    memtoreg, memwrite: out std_logic;
    pcsrc, alusrc:      out std_logic;
    regdst, regwrite:   out std_logic;
    jump:               out std_logic;
    alucontrol:         out std_logic_vector(2 downto 0)
  );
end;

architecture struct of controller is
  component maindec
    port (
      op:                 in  std_logic_vector(5 downto 0);
      memtoreg, memwrite: out std_logic;
      branch, alusrc:     out std_logic;
      regdst, regwrite:   out std_logic;
      jump:               out std_logic;
      aluop:              out std_logic_vector(1 downto 0)
    );
  end component;
  
  component aludec
    port (
      funct:      in  std_logic_vector(5 downto 0);
      aluop:      in  std_logic_vector(1 downto 0);
      alucontrol: out std_logic_vector(2 downto 0)
    );
  end component;

  signal aluop:  std_logic_vector(1 downto 0);
  signal branch: std_logic;
begin
  md: maindec port map(op, memtoreg, memwrite, branch,
                       alusrc, regdst, regwrite, jump, aluop);
  ad: aludec port map(funct, aluop, alucontrol);

  pcsrc <= branch and zero;
end;
