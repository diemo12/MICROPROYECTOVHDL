library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package paquete_parqueo is

    component divisor_1hz is
        port (
            clk_50Mhz : in  std_logic;
            rst       : in  std_logic;
            clk_1hz   : out std_logic
        );
    end component;

    component control_parqueo is
        port (
            clk_1hz                : in  std_logic;
            sensor                 : in  std_logic; 
            rst                    : in  std_logic;
            contador_35unidades    : out std_logic_vector(3 downto 0);
            contador_35decenas     : out std_logic_vector(3 downto 0);
            contador_extraunidades : out std_logic_vector(3 downto 0);
            contador_extradecenas  : out std_logic_vector(3 downto 0);
            alarma                 : out std_logic;
            felicitacion           : out std_logic
        );
    end component;

    component segundo_comp is
        port (
            g : in  std_logic_vector(3 downto 0);
            f : out std_logic_vector(6 downto 0)
        );
    end component;

end package paquete_parqueo;