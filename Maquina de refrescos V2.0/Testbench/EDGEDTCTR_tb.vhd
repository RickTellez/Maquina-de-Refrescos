library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR_tb is

end EDGEDTCTR_tb;

architecture TB of EDGEDTCTR_tb is

    --Declaramos el detector de flancos 
    component EDGEDTCTR
        port (
            CLK : in std_logic;
            MCEDGE_IN : in std_logic;
            MCEDGE_OUT : out std_logic;
            MCEDGE_IN2 : in std_logic;
            MCEDGE_OUT2 : out std_logic;
            MCEDGE_IN3 : in std_logic;
            MCEDGE_OUT3 : out std_logic;
            MCEDGE_IN4 : in std_logic;
            MCEDGE_OUT4 : out std_logic
        );
    end component;

    -- Señales para conectar la entidad y testbench 
    signal CLK_tb : std_logic := '0';
    signal MCEDGE_IN_tb : std_logic := '0';
    signal MCEDGE_OUT_tb : std_logic;
    signal MCEDGE_IN2_tb : std_logic := '0';
    signal MCEDGE_OUT2_tb : std_logic;
    signal MCEDGE_IN3_tb : std_logic := '0';
    signal MCEDGE_OUT3_tb : std_logic;
    signal MCEDGE_IN4_tb : std_logic := '0';
    signal MCEDGE_OUT4_tb : std_logic;

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciamos la entidad 
    UUT: EDGEDTCTR port map (
        CLK => CLK_tb,
        MCEDGE_IN => MCEDGE_IN_tb,
        MCEDGE_OUT => MCEDGE_OUT_tb,
        MCEDGE_IN2 => MCEDGE_IN2_tb,
        MCEDGE_OUT2 => MCEDGE_OUT2_tb,
        MCEDGE_IN3 => MCEDGE_IN3_tb,
        MCEDGE_OUT3 => MCEDGE_OUT3_tb,
        MCEDGE_IN4 => MCEDGE_IN4_tb,
        MCEDGE_OUT4 => MCEDGE_OUT4_tb
    );

    -- Generación del reloj
    clk_process : process
    begin
        while true loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2; --Espera medio ciclo (5 ns)
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2;--Espera medio ciclo (5 ns)
        end loop;
    end process;

    stim_proc: process
    begin
        --MCEDGE_IN
        MCEDGE_IN_tb <= '0';
        wait for 20 ns;
        MCEDGE_IN_tb <= '1'; --Flanco ascendente
        wait for 20 ns;
        MCEDGE_IN_tb <= '0';
        wait for 20 ns;

        --MCEDGE_IN2
        MCEDGE_IN2_tb <= '0';
        wait for 30 ns;
        MCEDGE_IN2_tb <= '1'; --Flanco ascendente
        wait for 20 ns;
        MCEDGE_IN2_tb <= '0';
        wait for 30 ns;

        --MCEDGE_IN3
        MCEDGE_IN3_tb <= '0';
        wait for 50 ns;
        MCEDGE_IN3_tb <= '1'; --Flanco ascendente
        wait for 20 ns;
        MCEDGE_IN3_tb <= '0';
        wait for 20 ns;

        --MCEDGE_IN4
        MCEDGE_IN4_tb <= '0';
        wait for 40 ns;
        MCEDGE_IN4_tb <= '1'; --Flanco ascendente
        wait for 20 ns;
        MCEDGE_IN4_tb <= '0';
        wait for 20 ns;

        wait; --Fin de la simulación
    end process;

end TB;
