----------------------------------------------------------------------
-- Disciplina : PCS3612 - Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : maindec.vhd                                             
----------------------------------------------------------------------
-- Descrição : Unidade de controle dos componentes do Fluxo de Dados
--             do MIPS excluindo a Unidade Lógico Aritmética
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity maindec is -- main control decoder
  port (
    op:                 in  std_logic_vector(5 downto 0);
    memtoreg, memwrite: out std_logic;
    alusrc:             out std_logic_vector(1 downto 0);
    branch, branch_neq: out std_logic;
    regdst, regwrite:   out std_logic;
    jump:               out std_logic;
    aluop:              out std_logic_vector(1 downto 0)
  );
end;

architecture behave of maindec is
  signal controls: std_logic_vector(10 downto 0);
begin
  process(all) begin
    case op is
      when "000000" => controls <= "11000000010"; -- RTYPE
      when "100011" => controls <= "10010001000"; -- LW
      when "101011" => controls <= "00010010000"; -- SW
      when "000100" => controls <= "00001000001"; -- BEQ
      when "000101" => controls <= "00000100001"; -- BNE
      when "001000" => controls <= "10010000000"; -- ADDI
      when "001101" => controls <= "10100000011"; -- ORI
      when "000010" => controls <= "00000000100"; -- J
      when others   => controls <= "-----------"; -- illegal op
    end case;
  end process;

  -- (regwrite, regdst, alusrc, branch, memwrite,W
  --  memtoreg, jump, aluop(1 downto 0)) <= controls;
 (regwrite, regdst, alusrc(1), alusrc(0), branch, branch_neq, memwrite,
  memtoreg, jump) <= controls(10 downto 2);
  aluop <= controls(1 downto 0);
end;
