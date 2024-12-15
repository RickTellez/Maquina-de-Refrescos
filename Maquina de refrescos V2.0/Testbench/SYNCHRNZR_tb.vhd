library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR_tb is

end SYNCHRNZR_tb;

architecture TB of SYNCHRNZR_tb is

    -- Declaramos Sincronizador 
    component SYNCHRNZR
        port (
            CLK : in std_logic; --Señal de reloj
            MC_IN : in std_logic; --Entrada izquierda
            MC_OUT : out std_logic; --Salida sincronizada de izquierda
            MC_IN2 : in std_logic; --Entrada derecha
            MC_OUT2 : out std_logic; --Salida sincronizada de derecha
            MC_IN3 : in std_logic;--Confirmación de moneda
            MC_OUT3 : out std_logic; --Salida sincronizada de confirmación de moneda
            MC_IN4 : in std_logic; --Señal de reset
            MC_OUT4 : out std_logic --Salida sincronizada de reset
        );
    end component;

    -- Señales para conectar entidad con el testbench
    signal CLK_tb : std_logic := '0';
    signal MC_IN_tb : std_logic := '0';
    signal MC_OUT_tb : std_logic;
    signal MC_IN2_tb : std_logic := '0';
    signal MC_OUT2_tb : std_logic;
    signal MC_IN3_tb : std_logic := '0';
    signal MC_OUT3_tb : std_logic;
    signal MC_IN4_tb : std_logic := '0';
    signal MC_OUT4_tb : std_logic;

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    --Instanciamos entidad Sincronizador
    UUT: SYNCHRNZR port map (
        CLK => CLK_tb,
        MC_IN => MC_IN_tb,
        MC_OUT => MC_OUT_tb,
        MC_IN2 => MC_IN2_tb,
        MC_OUT2 => MC_OUT2_tb,
        MC_IN3 => MC_IN3_tb,
        MC_OUT3 => MC_OUT3_tb,
        MC_IN4 => MC_IN4_tb,
        MC_OUT4 => MC_OUT4_tb
    );

    -- Generamos reloj
    clk_process : process
    begin
        while true loop
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;  --Espera medio ciclo (5 ns)
            CLK_tb <= '1';
            wait for CLK_PERIOD / 2; --Espera medio ciclo (5 ns)
        end loop;
    end process;

    stim_proc: process
    begin
    
        -- Simulamos rebote en MC_IN
        MC_IN_tb <= '1';
        wait for 5 ns;
        MC_IN_tb <= '0';
        wait for 10 ns;
        MC_IN_tb <= '1';
        wait for 20 ns;
        MC_IN_tb <= '0';
        wait for 15 ns;
        MC_IN_tb <= '1';
        wait for 50 ns;

        -- Simular rebote en MC_IN2
        MC_IN2_tb <= '1';
        wait for 8 ns;
        MC_IN2_tb <= '0';
        wait for 12 ns;
        MC_IN2_tb <= '1';
        wait for 25 ns;
        MC_IN2_tb <= '0';
        wait for 20 ns;
        MC_IN2_tb <= '1';
        wait for 40 ns;

        -- Simular señal estable en MC_IN3
        MC_IN3_tb <= '1';
        wait for 100 ns;
        MC_IN3_tb <= '0';
        wait for 100 ns;

        -- Simular rebote en MC_IN4
        MC_IN4_tb <= '1';
        wait for 5 ns;
        MC_IN4_tb <= '0';
        wait for 15 ns;
        MC_IN4_tb <= '1';
        wait for 10 ns;
        MC_IN4_tb <= '0';
        wait for 30 ns;

        -- Finalizar simulación
        wait;
    end process;

end TB;