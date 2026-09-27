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
-- Arquitectura que maneja toda la logica secuencial de los dos temporizadores y las condiciones del sensor.
-- Divido el conteo en variables BCD de unidades y decenas.
architecture comportamental of control_parqueo is
    signal t35_u, t35_d       : unsigned(3 downto 0) := (others => '0');
    signal textra_u, textra_d : unsigned(3 downto 0) := (others => '0');
    signal sensor_comp        : std_logic := '0';
    signal tiempo_35_listo    : std_logic := '0';
begin
-- Proceso sincronizado con el reloj de un segundo y con reset asincrono general.
-- Aqui detecto cuando la persona entra o sale mediante el registro sensor_comp que guarda el estado anterior del sensor.
-- Si la persona esta adentro, el temporizador corre hasta 35 segundos; al pasarse de ese tiempo, enciendo el led de alarma y arranco el temporizador extra.
-- Si la persona sale antes de los 35 segundos, apago las cuentas y activo el led de felicitacion.
process(clk_1hz, rst)

begin
    
    if rst = '1' then
        sensor_comp     <= '0';
        t35_u           <= (others => '0');
        t35_d           <= (others => '0');
        textra_u        <= (others => '0');
        textra_d        <= (others => '0');
        alarma          <= '0';
        felicitacion    <= '0';
        tiempo_35_listo <= '0';

    elsif rising_edge(clk_1hz) then
        sensor_comp <= sensor; 

        if sensor = '1' then
            felicitacion <= '0';

            
            if sensor_comp = '0' then
                t35_u           <= (others => '0');
                t35_d           <= (others => '0');
                textra_u        <= (others => '0');
                textra_d        <= (others => '0');
                alarma          <= '0';
                tiempo_35_listo <= '0';
            else
               
                if tiempo_35_listo = '0' then
                    if t35_u = 9 then
                        t35_u <= (others => '0');
                        t35_d <= t35_d + 1;
                    else
                        t35_u <= t35_u + 1;
                    end if;
                    
                    if t35_d = 3 and t35_u = 4 then
                        tiempo_35_listo <= '1';
                    end if;
                else
                    alarma <= '1';
                    if not (textra_d = 9 and textra_u = 9) then 
                        if textra_u = 9 then
                            textra_u <= (others => '0');
                            textra_d <= textra_d + 1;
                        else
                            textra_u <= textra_u + 1;
                        end if;
                    end if;
                end if;
            end if;

        else
          
            if sensor_comp = '1' and tiempo_35_listo = '0' and (t35_u > 0 or t35_d > 0) then
                felicitacion <= '1';
            end if;
            alarma <= '0';
            
        end if;
    end if;
end process;

    contador_35unidades    <= std_logic_vector(t35_u);
    contador_35decenas     <= std_logic_vector(t35_d);
    contador_extraunidades <= std_logic_vector(textra_u);
    contador_extradecenas  <= std_logic_vector(textra_d);

end comportamental;