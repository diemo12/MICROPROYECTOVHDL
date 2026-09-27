library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segundo_comp is 
    port (
        g : in  std_logic_vector(3 downto 0);
        f : out std_logic_vector(6 downto 0)
    );
end segundo_comp;
-- Arquitectura combinacional para convertir el codigo binario de 4 bits al display de 7 segmentos hecho en clase
-- Teniendo en cuenta que los displays de esta tarjeta son de anodo comun o activos en bajo, un cero enciende el segmento y un uno lo apaga.
architecture segundo_comp_arch of segundo_comp is
begin
-- Este proceso mira la entrada entrada con un case para dibujar los numeros del 0 al 9.
-- Si llega a entrar cualquier valor fuera de ese rango decimal, se deja todo lleno de  unos para dejar apagado el display por proteccion
    process (g) 
    begin
        case g is
            when "0000" => f <= "0000001";
            when "0001" => f <= "1001111";
            when "0010" => f <= "0010010";
            when "0011" => f <= "0000110";
            when "0100" => f <= "1001100";
            when "0101" => f <= "0100100";
            when "0110" => f <= "0100000";
            when "0111" => f <= "0001110";
            when "1000" => f <= "0000000";
            when "1001" => f <= "0000100";
            when others => f <= "1111111";
        end case;
    end process;
end segundo_comp_arch;