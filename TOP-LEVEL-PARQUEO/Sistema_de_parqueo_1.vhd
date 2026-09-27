library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.paquete_parqueo.all; 

entity sistema_de_parqueo_1 is
    port (
        CLOCK_50     : in  std_logic;                    
        SW_RESET     : in  std_logic;                    
        SW_SENSOR    : in  std_logic;                    
        LED_ALARMA   : out std_logic;                    
        LED_FELIZ    : out std_logic;                    
        HEX0         : out std_logic_vector(6 downto 0); 
        HEX1         : out std_logic_vector(6 downto 0); 
        HEX2         : out std_logic_vector(6 downto 0); 
        HEX3         : out std_logic_vector(6 downto 0)  
    );
end sistema_de_parqueo_1;
-- Esta es la entidad superior o estructural donde uno todos los archivos creados.
--Solo declaro las señales intermedias para mover los datos entre bloques y dejo que el package se encargue de los prototipos
architecture sistema_de_parqueo_1_arch of sistema_de_parqueo_1 is

    signal cable_1hz        : std_logic;
    signal bcd_35_u         : std_logic_vector(3 downto 0);
    signal bcd_35_d         : std_logic_vector(3 downto 0);
    signal bcd_extra_u      : std_logic_vector(3 downto 0);
    signal bcd_extra_d      : std_logic_vector(3 downto 0);

begin

    U_DIV : divisor_1hz
        port map (clk_50Mhz => CLOCK_50, rst => SW_RESET, clk_1hz => cable_1hz);

    U_CTRL : control_parqueo
        port map (
            clk_1hz                => cable_1hz,
            sensor                 => SW_SENSOR,
            rst                    => SW_RESET,
            contador_35unidades    => bcd_35_u,
            contador_35decenas     => bcd_35_d,
            contador_extraunidades => bcd_extra_u,
            contador_extradecenas  => bcd_extra_d,
            alarma                 => LED_ALARMA,
            felicitacion           => LED_FELIZ
        );

    DISP_35_UNIDADES    : segundo_comp port map (g => bcd_35_u, f => HEX0);
    DISP_35_DECENAS     : segundo_comp port map (g => bcd_35_d, f => HEX1);
    DISP_EXTRA_UNIDADES : segundo_comp port map (g => bcd_extra_u, f => HEX2);
    DISP_EXTRA_DECENAS  : segundo_comp port map (g => bcd_extra_d, f => HEX3);

end sistema_de_parqueo_1_arch;