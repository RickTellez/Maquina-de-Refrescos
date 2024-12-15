library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Precio_tb is
end Precio_tb;

architecture testbench of Precio_tb is
    --Declaramos la entidad Precio
    component Precio
        Port ( izq : in STD_LOGIC; --Señal de 'izquierda'
               clk : in STD_LOGIC; --Señal de reloj
               der : in STD_LOGIC; --Señal de 'derecha'
               p : out STD_LOGIC_VECTOR (9 downto 0)); --Precio
    end component;

    --Señales para conectar la entidad con testbench
    signal izq_tb : STD_LOGIC := '0';
    signal clk_tb : STD_LOGIC := '0';
    signal der_tb : STD_LOGIC := '0';
    signal p_tb : STD_LOGIC_VECTOR (9 downto 0);

    --Periodo de reloj (10 ns)
    constant clk_period : time := 10 ns;

begin
    --Instanciamos la entidad Precio
    UUT: Precio Port map (
        izq => izq_tb,
        clk => clk_tb,
        der => der_tb,
        p => p_tb
    );

    --Generación de la señal de reloj
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2; --Esperamos medio periodo de reloj
            clk_tb <= '1';
            wait for clk_period / 2; --Esperamos medio periodo de reloj
        end loop;
    end process;
    
    stim_proc: process
    begin
        --Estado inicial (A): Se espera que 'p' sea "0001100100" (precio=100)
        izq_tb <= '0';
        der_tb <= '0';
        wait for 10000 ps;

        -- Caso 1: Pasamos de A a B (der = '1', izq = '0')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

         -- Caso 2: Pasamos de B a C (der = '1', izq = '0')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Caso 3: Pasamos de C a B (der = '0', izq = '1')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Caso 4: Pasamos de B a A (der = '0', izq = '1')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Caso 5: Pasamos de A a B (der = '0', izq = '1')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Caso 6: Pasamos de B a A (der = '0', izq = '1')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        wait; --Fin de la simulacion
    end process;
end testbench;
