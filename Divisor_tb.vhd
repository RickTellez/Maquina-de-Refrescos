library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Divisor_tb is
end Divisor_tb;

architecture Behavioral of Divisor_tb is

    -- Instancia del componente bajo prueba
    component Divisor
        Port (
            clksal2 : out  STD_LOGIC; -- Salida dividida
            clksal : out  STD_LOGIC; -- Salida dividida
            clk : in  STD_LOGIC       -- Reloj de entrada
        );
    end component;

    -- Señales de prueba
    signal clk : STD_LOGIC := '0';
    signal clksal2 : STD_LOGIC;
    signal clksal : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns; -- Frecuencia de entrada 100 MHz

begin

    -- Instancia del DUT (Device Under Test)
    uut: Divisor
        Port map (
            clksal2 => clksal2,
            clksal => clksal,
            clk => clk
        );

    -- Generador de reloj
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Proceso para estímulos (aunque no se requiere entrada adicional para este diseño)
    stim_process : process
    begin
        -- Simular durante suficiente tiempo para observar salidas
        wait for 1000 ns; -- Tiempo de simulación
        wait; -- Detener simulación
    end process;

end Behavioral;
