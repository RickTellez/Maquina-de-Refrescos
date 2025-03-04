library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity Display is
    Port (
        a : in  STD_LOGIC_VECTOR (9 downto 0); --Acumulado en Tot
        b : in  STD_LOGIC_VECTOR (9 downto 0); --Cambio si acumulado >= precio
        an : out  STD_LOGIC_VECTOR (7 downto 0); --Anodos para 8 displays
        p : in  STD_LOGIC_VECTOR (9 downto 0); --Precio del refresco
        clk : in  STD_LOGIC; --Señal de reloj
        leds : in  STD_LOGIC_VECTOR (4 downto 0); --Leds de error
        seg : out  STD_LOGIC_VECTOR (6 downto 0) --Display de 7 segmentos
    );
end Display;

architecture Behavioral of Display is
    --Señales auxiliares para decodificar las unidades, decenas y centenas 
    signal u_a, d_a, c_a : std_logic_vector(6 downto 0); --Señales para acumulado
    signal u_b, d_b, c_b : std_logic_vector(6 downto 0); --Señales para precio
    signal u, d, c, u2, d2, c2 : std_logic_vector(6 downto 0); --Unidades, decenas y centenas para mostrar en displays
    signal letra, letra2 : std_logic_vector(6 downto 0); -- c-Cambio, A-acumulado
    signal sel : integer range 0 to 7 := 0; --Selector para intercambiar entre anodos
    signal dato : std_logic_vector(6 downto 0); --dato a mostrar en display

begin

    -- Contador de selección de dígitos
    process (clk)
    begin
        if rising_edge(clk) then
            sel <= (sel + 1) mod 8; --Incrementa el valor del selector para encender cada uno de los anodos 
        end if;
    end process;

    --Decodificador de ánodos comunes (selecciona el ánodo para cada dígito del display)
    process(sel)
    begin
        case sel is
            when 0 => an <= "11111110";  --Activa el primer dígito
            when 1 => an <= "11111101";  --Activa el segundo dígito
            when 2 => an <= "11111011";  --Activa el tercer dígito
            when 3 => an <= "11110111";  --Activa el cuarto dígito
            when 4 => an <= "11101111";  --Activa el quinto dígito
            when 5 => an <= "11011111";  --Activa el sexto dígito
            when 6 => an <= "10111111";  --Activa el séptimo dígito
            when others => an <= "01111111";  --Activa el octavo dígito
        end case;
    end process;

    -- Asignación de valores para precio
    process (p, leds)
    begin
        if p = "0001100100" and leds= "00000" then -- 100
            letra2 <= "0001101"; -- Refresco d
            u2 <="0000000";
            d2 <="0000000";
            c2 <="0000001";
        elsif p = "1000010010" and leds="00000" then -- 530
            letra2 <= "0001110"; -- Refresco E
            u2 <="0000000";
            d2 <="0000011";
            c2 <="0000101";
        elsif p = "0100011000" and leds="00000" then -- 280
            letra2 <= "0001111"; -- Refresco F
            u2 <="0000000";
            d2 <="0001000";
            c2 <="0000010";
        else 
            letra2 <= "0001110"; -- Error
            u2 <="0010001";
            d2 <="0010000";
            c2 <="0010000";
        end if;
    end process;

    --Separamos lo acumulado en unidades, decenas y centenas 
    process (a)
        variable a_decimal : integer;
    begin
        a_decimal := to_integer(unsigned(a)); 
        u_a <= std_logic_vector(to_unsigned(a_decimal mod 10, 7)); --Unidades de acumulado
        d_a <= std_logic_vector(to_unsigned((a_decimal / 10) mod 10, 7)); --Decenas de acumulado
        c_a <= std_logic_vector(to_unsigned((a_decimal / 100) mod 10, 7)); --Centenas de acumulado
    end process;

    --Separamos el precio en unidades, decenas y centenas 
    process (b)
        variable b_decimal : integer;
    begin
        b_decimal := to_integer(unsigned(b)); -- Convertir b a decimal
        u_b <= std_logic_vector(to_unsigned(b_decimal mod 10, 7)); -- Unidades de precio de refresco
        d_b <= std_logic_vector(to_unsigned((b_decimal / 10) mod 10, 7)); -- Decenas de precio de refresco
        c_b <= std_logic_vector(to_unsigned((b_decimal / 100) mod 10, 7)); -- Centenas de precio de refresco
    end process;

    process (b,u,d,c,u_a,d_a,c_a,u_b,d_b,c_b, leds)
    begin
        if b = "1111111111" and leds="00000" then -- acumulado < precio
            letra <= "0001010"; -- Modo de letra 'A'
            u <=u_a;
            d <=d_a;
            c <=c_a;
        elsif b /= "1111111111" and leds="00000" then -- acumulado >= precio
            letra <= "0001100"; -- Otro modo 'c'
            u <=u_b;
            d <=d_b;
            c <=c_b;
        else  -- acumulado > precio y sw_c= '0'
            letra <= "0010000"; -- Error
            u <=u_a;
            d <=d_a;
            c <=c_a;
        end if;    
        
    end process;

    -- Selector de datos MUX para la salida final dato
    process(u, d, c, u2, d2, c2, letra, letra2, sel)
    begin
        case sel is
            when 0 => dato <= u; -- Unidades 
            when 1 => dato <= d; -- Decenas 
            when 2 => dato <= c; -- Centenas 
            when 3 => dato <= letra; -- 'A' o 'c'
            when 4 => dato <= u2; -- Unidades de p    
            when 5 => dato <= d2; -- Decenas de p
            when 6 => dato <= c2; -- Centenas de p
            when 7 => dato <= letra2; -- Letra de refresco
            when others => dato <= (others => '1'); --Apagara el display
        end case;
    end process;

    -- Decodificador a display
    process(dato)
    begin
        case dato is
            when "0000000" => seg <= "0000001"; -- 0
            when "0000001" => seg <= "1001111"; -- 1
            when "0000010" => seg <= "0010010"; -- 2
            when "0000011" => seg <= "0000110"; -- 3
            when "0000100" => seg <= "1001100"; -- 4
            when "0000101" => seg <= "0100100"; -- 5
            when "0000110" => seg <= "0100000"; -- 6
            when "0000111" => seg <= "0001111"; -- 7
            when "0001000" => seg <= "0000000"; -- 8
            when "0001001" => seg <= "0000100"; -- 9
            when "0001010" => seg <= "0001000"; -- A
            when "0001100" => seg <= "1110010"; -- C
            when "0001101" => seg <= "1000010"; -- d
            when "0001110" => seg <= "0110000"; -- E
            when "0001111" => seg <= "0111000"; -- F
            when "0010000" => seg <= "1111010"; -- r
            when "0010001" => seg <= "1100010"; -- o
            when others => seg <= "1111111"; -- Apagado
        end case;
    end process;

end Behavioral;