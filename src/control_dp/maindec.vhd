----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : maindec.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Unidade de controle dos componentes do Fluxo de Dados
--             do MIPS excluindo a Unidade L�gico Aritm�tica
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity maindec is -- main control decoder
  port (
    op:                 in  std_logic_vector(5 downto 0);
    memtoreg, memwrite: out std_logic;
    alusrc:             out std_logic;
    branch, branch_neq: out std_logic;
    regdst, regwrite:   out std_logic;
    jump:               out std_logic;
    aluop:              out std_logic_vector(1 downto 0)
  );
end;

architecture behave of maindec is
  signal controls: std_logic_vector(9 downto 0);
begin
  process(all) begin
    case op is
      when "000000" => controls <= "1100000010"; -- RTYPE
      when "100011" => controls <= "1010001000"; -- LW
      when "101011" => controls <= "0010010000"; -- SW
      when "000100" => controls <= "0001000001"; -- BEQ
      when "000101" => controls <= "0000100001"; -- BNE
      when "001000" => controls <= "1010000000"; -- ADDI
      when "001101" => controls <= "1010000011"; -- ORI
      when "000010" => controls <= "0000000100"; -- J
      when others   => controls <= "----------"; -- illegal op
    end case;
  end process;

  -- (regwrite, regdst, alusrc, branch, memwrite,W
  --  memtoreg, jump, aluop(1 downto 0)) <= controls;
 (regwrite, regdst, alusrc, branch, branch_neq, memwrite,
  memtoreg, jump) <= controls(9 downto 2);
  aluop <= controls(1 downto 0);
end;
