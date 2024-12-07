library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tot_tb is
-- No tiene puertos, ya que es un testbench.
end Tot_tb;

architecture Behavioral of Tot_tb is

    -- Declaración de señales para conectar al DUT (Device Under Test)
    signal ent_tb : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    signal sal_tb : STD_LOGIC_VECTOR (9 downto 0);
    signal load_tb : STD_LOGIC := '0';
    signal clr_tb : STD_LOGIC := '0';
    signal clk_tb : STD_LOGIC := '0';

begin

    -- Instancia del DUT
    UUT: entity work.Tot
        port map (
            ent => ent_tb,
            sal => sal_tb,
            load => load_tb,
            clr => clr_tb,
            clk => clk_tb
        );

    -- Generación del reloj
    clk_process: process
    begin
        clk_tb <= '0';
        wait for 10 ns;  -- Periodo de 20 ns (frecuencia de 50 MHz)
        clk_tb <= '1';
        wait for 10 ns;
    end process;

    -- Estímulos para probar el diseño
    stimulus_process: process
    begin
        -- Prueba de reinicio
        clr_tb <= '1';    -- Activar reset
        wait for 20 ns;
        clr_tb <= '0';    -- Desactivar reset
        
        -- Prueba de carga
        ent_tb <= "1010101010";  -- Asignar valor a la entrada
        load_tb <= '1';          -- Activar load
        wait for 20 ns;
        load_tb <= '0';          -- Desactivar load
        
        -- Cambiar valor sin activar load
        ent_tb <= "1111111111";
        wait for 40 ns;
        
        -- Reactivar load
        load_tb <= '1';
        wait for 20 ns;
        load_tb <= '0';

        wait for 50 ns; -- Tiempo extra para observar comportamiento
        
                -- Prueba de reinicio
        clr_tb <= '1';    -- Activar reset
        wait for 20 ns;
        clr_tb <= '0';    -- Desactivar reset

        -- Finalizar simulación
        wait;
    end process;

end Behavioral;