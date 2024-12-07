library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Precio_tb is
end Precio_tb;

architecture testbench of Precio_tb is
    -- Component declaration of the unit under test (UUT)
    component Precio
        Port ( izq : in STD_LOGIC;
               clk : in STD_LOGIC;
               der : in STD_LOGIC;
               p : out STD_LOGIC_VECTOR (9 downto 0));
    end component;

    -- Testbench signals
    signal izq_tb : STD_LOGIC := '0';
    signal clk_tb : STD_LOGIC := '0';
    signal der_tb : STD_LOGIC := '0';
    signal p_tb : STD_LOGIC_VECTOR (9 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: Precio Port map (
        izq => izq_tb,
        clk => clk_tb,
        der => der_tb,
        p => p_tb
    );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Initial state (A): Expected p = "0001100100"
        izq_tb <= '0';
        der_tb <= '0';
        wait for 10000 ps;

        -- Test case 1: Move from A to B (der = '1', izq = '0')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Test case 2: Move from B to C (der = '1', izq = '0')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Test case 3: Move from C to B (der = '1', izq = '0')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Test case 4: Move from B to A (der = '0', izq = '1')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Test case 5: Move from A to B (der = '0', izq = '1')
        der_tb <= '1';
        izq_tb <= '0';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Test case 6: Move from B to A (der = '0', izq = '1')
        der_tb <= '0';
        izq_tb <= '1';
        wait for 10000 ps;
        der_tb <= '0';
        izq_tb <= '0';
        wait for 10000 ps;

        -- Stop simulation
        wait;
    end process;
end testbench;
