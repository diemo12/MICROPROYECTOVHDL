library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.paquete_parqueo.all; 
--(BTN_ACCION):
-- Antes: Existían 3 botones separados (BTN_START, BTN_STOP, BTN_RESET).
-- Ahora: Se eliminaron los 3 y se reemplazaron por uno solo (`BTN_ACCION`), el cual hace
-- todas las funciones según cuánto tiempo se mantenga presionado.
-- DETECCIÓN DE PULSACIÓN CORTA VS. LARGA (Contador de tiempo de presión):
-- Se agregó el contador `press_cnt` y dos constantes de tiempo:
-- `LIMITE_REBOTE` (2.500.000 ciclos = 50 milisegundos): Sirve como filtro antirrebote
--  para ignorar ruidos eléctricos al presionar.
--  LIMITE_RESET` (100.000.000 ciclos = 2 segundos exactos a 50 MHz).
-- NUEVA LÓGICA DE CONTROL:
-- PULSACIÓN CORTA (clic rápido, entre 50 ms y 2 s): Alterna el estado (`running <= not running`).
-- Si estaba pausado arranca; si estaba contando se pausa (función Play/Pausa en un solo botón).
-- PULSACIÓN LARGA (mantener presionado por 2 segundos): Cuando `press_cnt` llega a 100 millones,
-- se activa el RESET automático (pone en 0 los minutos, las decenas, las unidades y detiene el conteo).
-- RESET TOTALMENTE SINCRÓNICO:
-- Antes: El botón de reset reiniciaba el sistema de forma asíncrona (`if BTN_RESET = '0' ... elsif rising_edge`).
-- Ahora: Todo el proceso depende exclusivamente del flanco de reloj `rising_edge(CLOCK_50)`.

entity cronometro_top is
    port (
        CLOCK_50   : in  std_logic;
        BTN_ACCION : in  std_logic; 
        point		 : out  std_logic;
        HEX0       : out std_logic_vector(6 downto 0); 
        HEX1       : out std_logic_vector(6 downto 0); 
        HEX2       : out std_logic_vector(6 downto 0)  
    );
end cronometro_top;

architecture comportamental of cronometro_top is
    signal clk_1hz_cable : std_logic;
    signal clk_1hz_sync  : std_logic_vector(1 downto 0);
    signal tick_1s       : std_logic;


    signal running       : std_logic := '0'; 
    signal press_cnt     : integer range 0 to 100000005 := 0; 
    
    constant LIMITE_REBOTE : integer := 2500000;   
    constant LIMITE_RESET  : integer := 100000000; 

    signal min   : unsigned(3 downto 0) := (others => '0');
    signal sec_d : unsigned(3 downto 0) := (others => '0');
    signal sec_u : unsigned(3 downto 0) := (others => '0');

begin

 
    U_RELOJ: divisor_1hz 
        port map (
            clk_50Mhz => CLOCK_50,
            rst       => '0', 
            clk_1hz   => clk_1hz_cable
        );
    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
        
            clk_1hz_sync(0) <= clk_1hz_cable;
            clk_1hz_sync(1) <= clk_1hz_sync(0);

            if clk_1hz_sync(0) = '1' and clk_1hz_sync(1) = '0' then
                tick_1s <= '1';
            else
                tick_1s <= '0';
            end if;

           
            if BTN_ACCION = '0' then
               
                if press_cnt <= LIMITE_RESET then
                    press_cnt <= press_cnt + 1;
                end if;
                
                
                if press_cnt = LIMITE_RESET then
                    running <= '0';
                    min     <= (others => '0');
                    sec_d   <= (others => '0');
                    sec_u   <= (others => '0');
                end if;
            else
                
                if press_cnt > LIMITE_REBOTE and press_cnt < LIMITE_RESET then
                    running <= not running; 
                end if;
                
                press_cnt <= 0;
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
    point<= '0';
    DISP_SEC_U : segundo_comp port map (g => std_logic_vector(sec_u), f => HEX0);
    DISP_SEC_D : segundo_comp port map (g => std_logic_vector(sec_d), f => HEX1);
    DISP_MIN   : segundo_comp port map (g => std_logic_vector(min),   f => HEX2);

end comportamental;