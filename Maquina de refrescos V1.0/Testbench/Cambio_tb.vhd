library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Cambio_tb is
-- Testbench no tiene puertos.
end Cambio_tb;

architecture Behavioral of Cambio_tb is

    -- Declaración de señales para conectar al DUT (Device Under Test)
    signal a_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal b_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal Camb_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');

begin

    -- Instancia del DUT
    UUT: entity work.Cambio
        port map (
            a => a_tb,
            b => b_tb,
            Camb => Camb_tb
        );

    -- Proceso para aplicar estímulos
    stimulus_process: process
    begin
        -- Caso 1: a < b
        a_tb <= "0000000101"; -- a = 5
        b_tb <= "0000001010"; -- b = 10
        wait for 20 ns;
        
        -- Caso 2: a >= b (a = b)
        a_tb <= "0000001010"; -- a = 10
        b_tb <= "0000001010"; -- b = 10
        wait for 20 ns;

        -- Caso 3: a >= b (a > b)
        a_tb <= "0000010100"; -- a = 20
        b_tb <= "0000001010"; -- b = 10
        wait for 20 ns;

        -- Caso 4: a < b nuevamente
        a_tb <= "0000000011"; -- a = 3
        b_tb <= "0000001010"; -- b = 10
        wait for 20 ns;

        -- Finalizar simulación
        wait;
    end process;

end Behavioral;