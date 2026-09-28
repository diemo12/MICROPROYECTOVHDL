library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- El módulo divisor_1hz opera de forma síncrona contando los flancos de subida del reloj maestro de 50 MHz mediante un registro interno de enteros de 0 a 24.999.999
-- cada vez que el acumulador alcanza dicho límite equivalente a medio segundo exacto se reinicia a cero
        rst       : in std_logic;
        clk_1hz   : out std_logic
    );
end divisor_1hz;

architecture divisor_1hz_arch of divisor_1hz is
	 signal count : integer range 0 to 24999999 := 0;
    signal clk_out : std_logic := '0';
begin
    process(clk_50Mhz, rst)
    begin
        if rst = '1' then
            count <= 0;
            clk_out <= '0';
        elsif rising_edge(clk_50Mhz) then
            if count = 24999999 then 
                count <= 0;
                clk_out <= not clk_out;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    clk_1hz <= clk_out;
end divisor_1hz_arch;
