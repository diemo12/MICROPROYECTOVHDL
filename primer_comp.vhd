library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity primer_comp is port (
    k : in integer range 0 to 9;
    d : out std_logic_vector(3 downto 0));
end primer_comp;

architecture funcional of primer_comp is
begin

    process (k)
    begin
        if k = 0 then
            d <= "0000";
        elsif k = 1 then
            d <= "0001";
        elsif k = 2 then
            d <= "0010";
        elsif k = 3 then
            d <= "0011";
        elsif k = 4 then
            d <= "0100";
        elsif k = 5 then
            d <= "0101";
        elsif k = 6 then
            d <= "0110";
        elsif k = 7 then
            d <= "0111";
        elsif k = 8 then
            d <= "1000";
        elsif k = 9 then
            d <= "1001";
        end if;
    end process;

end funcional;
	

	