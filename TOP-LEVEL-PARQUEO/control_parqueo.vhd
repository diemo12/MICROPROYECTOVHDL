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
    signal tiempo_35s : integer range 0 to 35 := 0;
    signal tiempo_extra : integer range 0 to 99 := 0;
    type tipo_estado is (LIBRE, CONTANDO_35, EXTRA_TIEMPO, FIN_FELIZ);
    signal estado_actual : tipo_estado := LIBRE;
begin
    process(clk_1hz, rst)
    begin
        if rst = '1' then
            estado_actual <= LIBRE;
            tiempo_35s <= 0;
            tiempo_extra <= 0;
            alarma <= '0';
            felicitacion <= '0';
        elsif rising_edge(clk_1hz) then
            case estado_actual is
                when LIBRE =>
                    tiempo_35s <= 0;
                    tiempo_extra <= 0;
                    alarma <= '0';
                    felicitacion <= '0';
                    if sensor = '1' then
                        estado_actual <= CONTANDO_35;
                    end if;
                    
                when CONTANDO_35 =>
                    if sensor = '0' then
                        estado_actual <= FIN_FELIZ;
                        felicitacion <= '1';
                    else
                        if tiempo_35s < 35 then
                            tiempo_35s <= tiempo_35s + 1;
                        else
                            estado_actual <= EXTRA_TIEMPO;
                            alarma <= '1';
                        end if;
                    end if;
                    
                when EXTRA_TIEMPO =>
                    if sensor = '0' then
                        estado_actual <= LIBRE;
                    else
                        if tiempo_extra < 99 then
                            tiempo_extra <= tiempo_extra + 1;
                        end if;
                    end if;
                    
                when FIN_FELIZ =>
                    if sensor = '1' then 
                        estado_actual <= CONTANDO_35;
                        felicitacion <= '0';
                        tiempo_35s <= 0;
                    end if;
            end case;
        end if;
    end process;

    contador_35unidades    <= std_logic_vector(to_unsigned(tiempo_35s mod 10, 4));
    contador_35decenas     <= std_logic_vector(to_unsigned(tiempo_35s / 10, 4));
    contador_extraunidades <= std_logic_vector(to_unsigned(tiempo_extra mod 10, 4));
    contador_extradecenas  <= std_logic_vector(to_unsigned(tiempo_extra / 10, 4));
end comportamental;