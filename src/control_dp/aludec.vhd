----------------------------------------------------------------------
-- Disciplina : PCS3612 ? Organiza��o e Arquitetura de Computadores I 
-- Professor(a): Profa. Dra. C�ntia Borges Margi                      
-- Projeto :  Implementa��o do MIPS pipeline                          
-- Autores :                                                          
--   Jo�o Victor Marques de Oliveira | N� USP: 9344790                
--   Matheus Felipe Gomes            | N� USP: 8993198                
-- Data de cria��o : 21/11/2019       
-- Arquivo : aludec.vhd                                             
----------------------------------------------------------------------
-- Descri��o : Decodificador para o controle da Unidade L�gico 
--             Aritm�tica
----------------------------------------------------------------------

library IEEE; use IEEE.std_logic_1164.all;

entity aludec is
  port (
    funct:      in  std_logic_vector(5 downto 0);
    aluop:      in  std_logic_vector(1 downto 0);
    alucontrol: out std_logic_vector(2 downto 0)
  );
end;

architecture behave of aludec is
begin
  process(all) begin
    case aluop is
      when "00" => alucontrol <= "010"; -- add (for lw/sw/addi)
      when "01" => alucontrol <= "110"; -- sub (for beq)
      when others => case funct is      -- R-type instructions
                         when "100000" => alucontrol <= "010"; -- add
                         when "100010" => alucontrol <= "110"; -- sub
                         when "100100" => alucontrol <= "000"; -- and
                         when "100101" => alucontrol <= "001"; -- or
                         when "101010" => alucontrol <= "111"; -- slt
                         when others   => alucontrol <= "---"; -- ???
                     end case;
    end case;
  end process;
end;
