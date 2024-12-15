library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Sumador8_tb is
end Sumador8_tb;

architecture testbench of Sumador8_tb is

    component Sumador8 -- Declaramos entidad Sumador8 
        Port ( a : in  STD_LOGIC_VECTOR (9 downto 0); -- Acumulado actual
               b : in  STD_LOGIC_VECTOR (3 downto 0); -- Monedas que entran
               suma : out  STD_LOGIC_VECTOR (9 downto 0));
    end component;

    -- Señales internas para conectar el testbench con la entidad
    signal a_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal b_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal suma_tb : STD_LOGIC_VECTOR(9 downto 0);

begin
    
    -- Instanciamos de la entidad Sumador
    UUT: Sumador8 Port map (
        a => a_tb,
        b => b_tb,
        suma => suma_tb
    );

    
    stim_proc: process
    begin
        --Caso 1: Suma de 2 + 10
        a_tb <= "0000000010"; -- 2
        b_tb <= "0001";       -- 10 centimos
        wait for 10 ns;

        --Caso 2: Suma de 2 + 20
        a_tb <= "0000000010"; -- 2
        b_tb <= "0010";       -- 20 centimos
        wait for 10 ns;

        --Caso 3: Suma de 2 + 50
        a_tb <= "0000000010"; -- 2
        b_tb <= "0100";       -- 50 centimos 
        wait for 10 ns;

        --Caso 4: Suma de 2 + 100
        a_tb <= "0000000010"; -- 2
        b_tb <= "1000";       -- 100 centimos
        wait for 10 ns;

        --Caso 5: Suma de 2 + 180
        a_tb <= "0000000010"; -- 2
        b_tb <= "1111";       -- 180 centimos
        wait for 10 ns;
        
        --Caso 6: Suma de 2 + 110
        a_tb <= "0000000010"; -- 2
        b_tb <= "1001";       -- 110 centimos 
        wait for 10 ns;
        
        --Caso 7: Suma de 2 + 120
        a_tb <= "0000000010"; -- 2
        b_tb <= "1010";       -- 120 centimos
        wait for 10 ns;
        
        --Caso 8: Suma de 2 + 130
        a_tb <= "0000000010"; -- 2
        b_tb <= "1011";       -- 130 centimos
        wait for 10 ns;
        
        --Caso 9: Suma de 2 + 150
        a_tb <= "0000000010"; -- 2
        b_tb <= "1100";       -- 150 centimos
        wait for 10 ns;
        

        -- Fin de simulacion
        wait;
    end process;
end testbench;

