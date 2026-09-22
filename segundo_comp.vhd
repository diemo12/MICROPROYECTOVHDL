library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity segundo_comp is port (
g: in std_logic_vector(3 downto 0);
f: out std_logic_vector(6 downto 0));
end segundo_comp;
architecture segundo_comp_arch of segundo_comp is
begin
process (g) begin
case g is
when "0000" =>f<= "0000001";
when "0001" =>f<= "1001111";
when "0010" =>f<= "0010010";
when "0011" =>f<= "0000110";
when "0100" =>f<= "1001100";
when "0101" =>f<= "0100100";
when "0110" =>f<= "0100000";
when "0111" =>f<= "0001110";
when "1000" =>f<= "0000000";
when "1001" =>f<= "0000100";
when others =>f<= "1111111";
end case;
end process;
end segundo_comp_arch;