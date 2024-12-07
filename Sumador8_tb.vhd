library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Sumador8_tb is
end Sumador8_tb;

architecture testbench of Sumador8_tb is

    component Sumador8
        Port ( a : in  STD_LOGIC_VECTOR (9 downto 0);
               b : in  STD_LOGIC_VECTOR (3 downto 0);
               suma : out  STD_LOGIC_VECTOR (9 downto 0));
    end component;

    signal a_tb : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal b_tb : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal suma_tb : STD_LOGIC_VECTOR(9 downto 0);

begin
    
    UUT: Sumador8 Port map (
        a => a_tb,
        b => b_tb,
        suma => suma_tb
    );

    
    stim_proc: process
    begin
        -- Test case 1
        a_tb <= "0000000010"; -- 2
        b_tb <= "0001";       -- 1 (adds 10)
        wait for 10 ns;

        -- Test case 2
        a_tb <= "0000000010"; -- 2
        b_tb <= "0010";       -- 2 (adds 20)
        wait for 10 ns;

        -- Test case 3
        a_tb <= "0000000010"; -- 2
        b_tb <= "0100";       -- 4 (adds 50)
        wait for 10 ns;

        -- Test case 4
        a_tb <= "0000000010"; -- 2
        b_tb <= "1000";       -- 8 (adds 100)
        wait for 10 ns;

        -- Test case 5
        a_tb <= "0000000010"; -- 2
        b_tb <= "1111";       -- 15 (adds 180)
        wait for 10 ns;
        
        -- Test case 6
        a_tb <= "0000000010"; -- 2
        b_tb <= "1001";       -- 9 (adds 110)
        wait for 10 ns;
        
        -- Test case 7
        a_tb <= "0000000010"; -- 2
        b_tb <= "1010";       -- 10 (adds 120)
        wait for 10 ns;
        
        -- Test case 8
        a_tb <= "0000000010"; -- 2
        b_tb <= "1011";       -- 11 (adds 130)
        wait for 10 ns;
        
        -- Test case 9
        a_tb <= "0000000010"; -- 2
        b_tb <= "1100";       -- 12 (adds 150)
        wait for 10 ns;
        

        -- Stop simulation
        wait;
    end process;
end testbench;

