library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

--Entidad para obtener un divisor de frecuencia
entity Divisor is
    Port (
           clksal2 : out  STD_LOGIC; --Salida de f=1,525 KHz
           clksal : out  STD_LOGIC; --Salida de f=0,381 KHz
           clk : in  STD_LOGIC); --Señal de reloj f=100 MHz
end Divisor;

architecture Behavioral of Divisor is
    signal f: unsigned(23 downto 0) := (others => '0'); -- Contador de 24 bits (0 a 16.777.215)
begin

    process(clk )
    begin
    
        if rising_edge(clk) then
            f <= f + 1; -- Incrementamos contador hasta 16.777.215
        end if;
        
    end process;

    clksal2 <= f(15); -- 100 MHz / 2^16 = 1.525 KHz
    clksal <= f(17); -- 100 MHz / 2^18 = 0.381 KHz

end Behavioral;