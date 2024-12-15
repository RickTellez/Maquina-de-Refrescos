library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Divisor_tb is
end Divisor_tb;

architecture Behavioral of Divisor_tb is

    --Instanciamos Divisor
    component Divisor
        Port (
            clksal2 : out  STD_LOGIC; --Salida de frecuencia dividida (1.525 KHz)
            clksal : out  STD_LOGIC; --Salida de frecuencia dividida (0.381 KHz)
            clk : in  STD_LOGIC       --Señal de reloj de entrada (100 MHz)
        );
    end component;

    --Señales conectar entidad Divisor con testbench
    signal clk : STD_LOGIC := '0';
    signal clksal2 : STD_LOGIC;
    signal clksal : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns; --Frecuencia de entrada 100 MHz

begin

    --Instanciamos Divisor
    uut: Divisor
        Port map (
            clksal2 => clksal2,
            clksal => clksal,
            clk => clk
        );

    --Generador de reloj
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2; --Espera la mitad del período (5 ns)
            clk <= '1';
            wait for CLK_PERIOD / 2; --Espera la mitad del período (5 ns)
        end loop;
    end process;


    stim_process : process
    begin

        wait for 1000 ns; --Tiempo de simulación
        wait; --Fin de simulación
        
    end process;

end Behavioral;
