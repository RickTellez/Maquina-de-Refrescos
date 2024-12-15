library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Comparador8_tb is
end Comparador8_tb;

architecture testbench of Comparador8_tb is
    
    component Comparador8
        Port ( a : in  STD_LOGIC_VECTOR (9 downto 0); -- Dinero acumulado en Tot
               b : in  STD_LOGIC_VECTOR (9 downto 0); -- Precio del refresco
               e : out  STD_LOGIC; -- Error: '1' cuando sw_c = '0' y a > b
               c : out  STD_LOGIC ); -- '0' cuando a >= b
    end component;

    -- Señales internas para conectar el testbench con la entidad
    signal a_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal b_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal e_tb : STD_LOGIC;
    signal c_tb : STD_LOGIC;

begin
    
    -- Instanciamos de la entidad Comparador
    UUT: Comparador8 Port map (
        a => a_tb,
        b => b_tb,
        e => e_tb,
        c => c_tb
    );

    
    stim_proc: process
    begin
    
        -- Caso 1: a < b
        a_tb <= "0000000010"; -- 2
        b_tb <= "0000000101"; -- 5
        wait for 10 ns;
        -- Esperado: c = '1', e = '0'
        
        -- Caso 2: a = b
        a_tb <= "0000001001"; -- 9
        b_tb <= "0000001001"; -- 9
        wait for 10 ns;
        -- Esperado: c = '0', e = '0'
        
        -- Caso 3: a > b
        a_tb <= "0000010100"; -- 20
        b_tb <= "0000001110"; -- 14
        wait for 10 ns;
        -- Esperado: c = '0', e = '1'
        
        -- Caso 4: a < b
        a_tb <= "0001100100"; -- 100
        b_tb <= "0001101110"; -- 110
        wait for 10 ns;
        -- Esperado: c = '1', e = '0'

        -- Caso 5: a > b
        a_tb <= "0010100000"; -- 160
        b_tb <= "0010010110"; -- 150
        wait for 10 ns;
        -- Esperado: c = '0', e = '1'

        -- Fin de simulacion
        wait;
    end process;
end testbench;
