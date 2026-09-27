library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_parqueo is
    port (
        clk_1hz                : in std_logic;
        sensor                 : in std_logic; 
        rst                    : in std_logic;
        contador_35unidades    : out std_logic_vector(3 downto 0);
        contador_35decenas     : out std_logic_vector(3 downto 0);
        contador_extraunidades : out std_logic_vector(3 downto 0);
        contador_extradecenas  : out std_logic_vector(3 downto 0);
        alarma                 : out std_logic;
        felicitacion           : out std_logic
    );
end control_parqueo;

architecture comportamental of control_parqueo is
    signal tiempo_35s   : integer range 0 to 35 := 0;
    signal tiempo_extra : integer range 0 to 99 := 0;
    signal sensor_comp   : std_logic := '0';
begin

process(clk_1hz, rst)
begin
    if rst = '1' then
        sensor_comp   <= '0';
        tiempo_35s   <= 0;
        tiempo_extra <= 0;
        alarma       <= '0';
        felicitacion <= '0';

    elsif rising_edge(clk_1hz) then
        sensor_comp <= sensor; 

        if sensor = '1' then
            felicitacion <= '0';

            if sensor_comp = '0' then
                tiempo_35s   <= 0;
                tiempo_extra <= 0;
                alarma       <= '0';
            else
                if tiempo_35s < 35 then
                    tiempo_35s <= tiempo_35s + 1;
                else
                    alarma <= '1';
                    if tiempo_extra < 99 then
                        tiempo_extra <= tiempo_extra + 1;
                    end if;
                end if;
            end if;

        else
            if sensor_comp = '1' and tiempo_35s > 0 and tiempo_35s < 35 then
                felicitacion <= '1';
            end if;

            alarma       <= '0';
            tiempo_extra <= 0;
            tiempo_35s   <= 0;
        end if;

    end if;
end process;

    contador_35unidades    <= std_logic_vector(to_unsigned(tiempo_35s mod 10, 4));
    contador_35decenas     <= std_logic_vector(to_unsigned(tiempo_35s / 10, 4));
    contador_extraunidades <= std_logic_vector(to_unsigned(tiempo_extra mod 10, 4));
    contador_extradecenas  <= std_logic_vector(to_unsigned(tiempo_extra / 10, 4));

end comportamental;