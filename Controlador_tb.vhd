library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controlador_tb is
end Controlador_tb;

architecture testbench of Controlador_tb is
    -- Component declaration of the unit under test (UUT)
    component Controlador
        Port ( d : out  STD_LOGIC;
               clk : in  STD_LOGIC;
               rst : in  STD_LOGIC;
               sw_c : in  STD_LOGIC;
               tot_lt_s : in  STD_LOGIC;
               e : in  STD_LOGIC;
               leds : out  STD_LOGIC_VECTOR (4 downto 0);
               tot_ld : out  STD_LOGIC;
               tot_clr : out  STD_LOGIC;
               c : in  STD_LOGIC);
    end component;

    -- Testbench signals
    signal d_tb : STD_LOGIC;
    signal rst_tb : STD_LOGIC:= '0';
    signal clk_tb : STD_LOGIC := '0';
    signal sw_c_tb : STD_LOGIC := '0';
    signal tot_lt_s_tb : STD_LOGIC := '0';
    signal e_tb : STD_LOGIC := '0';
    signal leds_tb : STD_LOGIC_VECTOR (4 downto 0);
    signal tot_ld_tb : STD_LOGIC;
    signal tot_clr_tb : STD_LOGIC;
    signal c_tb : STD_LOGIC := '0';

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: Controlador Port map (
        d => d_tb,
        rst => rst_tb,
        clk => clk_tb,
        sw_c => sw_c_tb,
        tot_lt_s => tot_lt_s_tb,
        e => e_tb,
        leds => leds_tb,
        tot_ld => tot_ld_tb,
        tot_clr => tot_clr_tb,
        c => c_tb
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
        -- Test case 1: Initial state -> Espera state
        c_tb <= '0';
        sw_c_tb <= '0';
        tot_lt_s_tb <= '1';
        e_tb <= '0';
        wait for 100000 ps;

        -- Test case 2: Transition to suma state (c = '1')
        c_tb <= '1';
        tot_lt_s_tb <= '1';
        wait for 100000 ps;

        -- Test case 3: Transition back to despacha state (sw_c = '0') 
        c_tb <= '0';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;

        -- Test case 4: Transition to despacha state (sw_c = '1') 
        tot_lt_s_tb <= '0';
        sw_c_tb <= '1';
        wait for 100000 ps;

        -- Test case 5: Transition to error state (e = '1', sw_c = '0')
        sw_c_tb <= '0';
        e_tb <= '1';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;
        
        -- Test case 6: Transition to despacha state (e = '1', sw_c = '1')
        sw_c_tb <= '1';
        e_tb <= '1';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;

        -- Test case 7: Return to inicio state from error
        tot_lt_s_tb <= '1';
        wait for 100000 ps;

        -- Stop simulation
        wait;
    end process;
end testbench;

