library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity Controlador_tb is
end Controlador_tb;

architecture testbench of Controlador_tb is
    -- Component declaration of the unit under test (UUT)
    component Controlador
        Port ( d : out  STD_LOGIC; --'1' entrega del refresco (led)
              clk : in  STD_LOGIC; --Señal de reloj
              rst : in  STD_LOGIC; --Reset
              sw_c : in  STD_LOGIC;  --1 Da cambio, 0 No da cambio
              tot_lt_s : in  STD_LOGIC; --'0' acumulado >= precio 
              e : in  STD_LOGIC; --'1' acumulado > precio y sw_c='0'
              leds : out  STD_LOGIC_VECTOR (4 downto 0); --"11111" Error cuando e='1'
              tot_ld : out  STD_LOGIC; --Permite cargar a Tot lo sumado en Sumador
              tot_clr : out  STD_LOGIC; --Limpia lo acumulado en Tot
              c : in  STD_LOGIC --Permite cargar la moneda (estado suma) 
               );
    end component;

    --Señales para conectar entidad con Testbench
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
    --Intanciamos entidad Controlador
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

    --Generación del reloj
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2; --Espera la mitad del periodo (5 ns)
            clk_tb <= '1';
            wait for clk_period / 2; --Espera la mitad del periodo (5 ns)
        end loop;
    end process;

    stim_proc: process
    begin
        --Caso 1: Estado inicial -> Estado espera
        c_tb <= '0';
        sw_c_tb <= '0';
        tot_lt_s_tb <= '1';
        e_tb <= '0';
        wait for 100000 ps;

        --Caso 2: Pasamos al estado suma (c = '1')
        c_tb <= '1';
        tot_lt_s_tb <= '1';
        wait for 100000 ps;

        --Caso 3: Pasamos de vuelta al estado despacha (sw_c = '0')
        c_tb <= '0';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;

        -- Caso 4: Pasamos al estado despacha (sw_c = '1')
        tot_lt_s_tb <= '0';
        sw_c_tb <= '1';
        wait for 100000 ps;

        -- Caso 5: Transición al estado error (e = '1', sw_c = '0')
        sw_c_tb <= '0';
        e_tb <= '1';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;
        
        -- Caso 6: Transición al estado despacha (e = '1', sw_c = '1')
        sw_c_tb <= '1';
        e_tb <= '1';
        tot_lt_s_tb <= '0';
        wait for 100000 ps;

        -- Caso 7: Regreso al estado inicio desde error
        tot_lt_s_tb <= '1';
        wait for 100000 ps;

        wait; --Fin de simulacion
    end process;
end testbench;

