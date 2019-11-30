----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organização e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. Cíntia Borges Margi                      
-- Projeto :  Implementação do MIPS pipeline                          
-- Autores :                                                          
--   João Victor Marques de Oliveira | Nº USP: 9344790                
--   Matheus Felipe Gomes            | Nº USP: 8993198                
-- Data de criação : 21/11/2019       
-- Arquivo : alu.vhd                                             
----------------------------------------------------------------------
-- Descrição : Unidade Lógico Aritmética do MIPS
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port (
    a, b:       in      std_logic_vector(31 downto 0);
    alucontrol: in      std_logic_vector(2 downto 0);
    result:     buffer  std_logic_vector(31 downto 0);
    zero:       out     std_logic
  );
end;

architecture behave of alu is
  signal condinvb, sum: std_logic_vector(31 downto 0);

  constant zeros: std_logic_vector(30 downto 0) := (others => '0') ;
begin
  condinvb <= not b when alucontrol(2) else b;
  sum <= std_logic_vector(unsigned(a) + unsigned(condinvb) + unsigned(zeros & alucontrol(2)));

  process(all) begin
    case alucontrol(1 downto 0) is
      when "00"   => result <= a and b;
      when "01"   => result <= a or b;
      when "10"   => result <= sum;
      when "11"   => result <= (0 => sum(31), others => '0');
      when others => result <= (others => 'X');
    end case;
  end process;

  zero <= '1' when result = X"00000000" else '0';
end;
