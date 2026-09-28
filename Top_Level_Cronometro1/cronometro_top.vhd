library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.paquete_parqueo.all; 
-- El divisor cuenta los 1 segundos exactos
-- Sincronizador de 1 segundo: Detecta justo el instante exacto en que pasa un segundo para eso sirven los tick 
-- Memoria de estado (running): Recuerda si el cronómetro está andando ('1') o en pausa ('0')
-- Procesos If :
-- Si está andando y pasa un segundo, suma 1 a las unidades de segundo.
-- Al llegar a 9 segundos, vuelve a 0 y le suma 1 a las decenas de segundo.
-- Al llegar a 59 segundos, todo vuelve a 0 y le suma 1 a los minutos.
-- Al llegar a 9 minutos con 59 segundos, se reinicia a 0.
-- Traductores de pantalla (segundo_comp): Toman los números binarios calculados y 
--  encienden los displays con respecto al segundo componente.

entity cronometro_top is
    port (
        CLOCK_50  : in  std_logic;
       
        BTN_START : in  std_logic; 
        BTN_STOP  : in  std_logic;
        BTN_RESET : in  std_logic;
       
        HEX0      : out std_logic_vector(6 downto 0); 
        HEX1      : out std_logic_vector(6 downto 0); 
        HEX2      : out std_logic_vector(6 downto 0)  
    );
end cronometro_top;

architecture comportamental of cronometro_top is

    signal clk_1hz_cable : std_logic;
    signal clk_1hz_sync  : std_logic_vector(1 downto 0);
    signal tick_1s       : std_logic;

    
    signal running       : std_logic := '0'; 
    
    
    signal min           : unsigned(3 downto 0) := (others => '0');
    signal sec_d         : unsigned(3 downto 0) := (others => '0');
    signal sec_u         : unsigned(3 downto 0) := (others => '0');

begin

    
    U_RELOJ: divisor_1hz 
        port map (
            clk_50Mhz => CLOCK_50,
            rst       => '0', 
            clk_1hz   => clk_1hz_cable
        );

    process(CLOCK_50, BTN_RESET)
    begin
      
        if BTN_RESET = '0' then 
            running <= '0';
            min     <= (others => '0');
            sec_d   <= (others => '0');
            sec_u   <= (others => '0');
            clk_1hz_sync <= "00";
            
        elsif rising_edge(CLOCK_50) then
        
           
            clk_1hz_sync(0) <= clk_1hz_cable;
            clk_1hz_sync(1) <= clk_1hz_sync(0);

            if clk_1hz_sync(0) = '1' and clk_1hz_sync(1) = '0' then
                tick_1s <= '1';
            else
                tick_1s <= '0';
            end if;

            
            if BTN_START = '0' then
                running <= '1';
            elsif BTN_STOP = '0' then
                running <= '0';
            end if;

          
            if running = '1' and tick_1s = '1' then
                if sec_u = 9 then
                    sec_u <= (others => '0');
                    if sec_d = 5 then
                        sec_d <= (others => '0');
                        if min = 9 then
                            min <= (others => '0'); 
                        else
                            min <= min + 1;
                        end if;
                    else
                        sec_d <= sec_d + 1;
                    end if;
                else
                    sec_u <= sec_u + 1;
                end if;
            end if;
            
        end if;
    end process;

  
    DISP_SEC_U : segundo_comp port map (g => std_logic_vector(sec_u), f => HEX0);
    DISP_SEC_D : segundo_comp port map (g => std_logic_vector(sec_d), f => HEX1);
    DISP_MIN   : segundo_comp port map (g => std_logic_vector(min),   f => HEX2);

end comportamental;