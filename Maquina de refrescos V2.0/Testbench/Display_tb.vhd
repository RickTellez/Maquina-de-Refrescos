library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_tb is

end Display_tb;

architecture Behavioral of Display_tb is

    -- Señales para conectar la entidad con el testbench
    signal a_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal b_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal p_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal clk_tb : STD_LOGIC := '0';
    signal an_tb : STD_LOGIC_VECTOR(7 downto 0);
    signal seg_tb : STD_LOGIC_VECTOR(6 downto 0);

    -- Período del reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciamos la entidad 
    UUT: entity work.Display
        port map (
            a => a_tb,
            b => b_tb,
            an => an_tb,
            p => p_tb,
            clk => clk_tb,
            seg => seg_tb
        );

    -- Generación del reloj
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2; --Esperamos la mitad del periodo (5 ns)
            clk_tb <= '1';
            wait for CLK_PERIOD / 2; --Esperamos la mitad del periodo (5 ns)
        end loop;
    end process;

    stimulus_process: process
    begin
        --Caso 1: Dinero insuficiente (b = "1111111111")
        p_tb <= "0001100100"; -- Precio = 100
        a_tb <= "0000111100"; -- Dinero ingresado = 60
        b_tb <= "1111111111"; -- Dinero insuficiente
        wait for 100 ns;

        --Caso 2: Dinero exacto (a = p, b = 0)
        a_tb <= "0001100100"; -- Dinero ingresado = 100
        b_tb <= "0000000000"; -- Sin cambio (dinero exacto)
        wait for 100 ns;

        --Caso 3: Dinero excedente (a > p, b = a - p)
        a_tb <= "0001111000"; -- Dinero ingresado = 120
        b_tb <= std_logic_vector(to_unsigned(120 - 100, 10)); -- Cambio = 20
        wait for 100 ns;

        --Caso 4: Otro precio
        p_tb <= "0100011000"; -- Precio = 280
        a_tb <= "0100100000"; -- Dinero ingresado = 320
        b_tb <= std_logic_vector(to_unsigned(320 - 280, 10)); -- Cambio = 40
        wait for 100 ns;

        wait; -- Finaliza simulación
    end process;

end Behavioral;
