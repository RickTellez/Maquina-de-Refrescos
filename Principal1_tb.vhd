library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Principal1_tb is
-- No se necesitan puertos en el testbench
end Principal1_tb;

architecture behavior of Principal1_tb is

    -- Componente bajo prueba
    component Principal1 is
        Port ( 
            mc : in  STD_LOGIC;
            izquierda : in  STD_LOGIC;
            derecha : in  STD_LOGIC;
            md : out  STD_LOGIC;
            mclk : in  STD_LOGIC;
            sw_c : in  STD_LOGIC;
            leds : out  STD_LOGIC_VECTOR (4 downto 0);
            reset : in  STD_LOGIC;
            ma : in  STD_LOGIC_VECTOR (3 downto 0);
            segmentos : out  STD_LOGIC_VECTOR (6 downto 0);
            anodos : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Señales para conectar con el DUT
    signal mc : STD_LOGIC := '0';
    signal izquierda : STD_LOGIC := '0';
    signal derecha : STD_LOGIC := '0';
    signal md : STD_LOGIC;
    signal mclk : STD_LOGIC := '0';
    signal sw_c : STD_LOGIC := '0';
    signal leds : STD_LOGIC_VECTOR(4 downto 0);
    signal reset : STD_LOGIC := '1';
    signal ma : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal segmentos : STD_LOGIC_VECTOR(6 downto 0);
    signal anodos : STD_LOGIC_VECTOR(7 downto 0);

    -- Constante para el periodo del reloj
    constant clk_period : time := 10 ns;
    constant wait_time : time := 10 ms; -- Tiempo entre acciones

begin

    -- Instancia del DUT (Dispositivo bajo prueba)
    uut: Principal1
        port map (
            mc => mc,
            izquierda => izquierda,
            derecha => derecha,
            md => md,
            mclk => mclk,
            sw_c => sw_c,
            leds => leds,
            reset => reset,
            ma => ma,
            segmentos => segmentos,
            anodos => anodos
        );

    -- Proceso para generar el reloj (mclk)
    clk_process : process
    begin
        while true loop
            mclk <= '0';
            wait for clk_period / 2;
            mclk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proceso para aplicar los estímulos de prueba
    stimuli: process
    begin
        -- Inicializar reset
        reset <= '1';  -- Activar reset
        wait for wait_time;
        reset <= '0';  -- Desactivar reset
        wait for wait_time;

        -- Caso 1: Precio = 530, cambio habilitado, insertar 180
        izquierda <= '0';
        derecha <= '1';     -- Precio: 530
        wait for wait_time;
        sw_c <= '1';        -- Habilitar cambio
        wait for wait_time;
        ma <= "1111";       -- Insertar 180
        wait for wait_time;
        mc <= '1';          -- Cargar dinero
        wait for wait_time;
        mc <= '0';          -- Detener carga de dinero
        wait for wait_time;

        -- Caso 2: Precio = 530, cambio habilitado, insertar 180
        izquierda <= '0';
        derecha <= '0';     -- Precio: 530
        wait for wait_time;
        sw_c <= '1';        -- Habilitar cambio
        wait for wait_time;
        ma <= "1111";       -- Insertar 180
        wait for wait_time;
        mc <= '1';          -- Cargar dinero
        wait for wait_time;
        mc <= '0';          -- Detener carga de dinero
        wait for wait_time;

        -- Caso 3: Precio = 530, cambio habilitado, insertar 180
        izquierda <= '0';
        derecha <= '0';     -- Precio: 530
        wait for wait_time;
        sw_c <= '1';        -- Habilitar cambio
        wait for wait_time;
        ma <= "1111";       -- Insertar 180
        wait for wait_time;
        mc <= '1';          -- Cargar dinero
        wait for wait_time;
        mc <= '0';          -- Detener carga de dinero
        wait for wait_time;

        -- Caso 4: Precio = 100, sin cambio, insertar 180
        izquierda <= '1';   -- Cambiar precio a 100
        derecha <= '0';
        wait for wait_time;
        sw_c <= '0';        -- Sin cambio
        wait for wait_time;
        ma <= "1111";       -- Insertar 180
        wait for wait_time;
        mc <= '1';          -- Cargar dinero
        wait for wait_time;
        mc <= '0';          -- Detener carga de dinero
        wait for wait_time;
        
        -- Caso 5: Precio = 100, sin cambio, insertar 180
        izquierda <= '1';   -- Cambiar precio a 100
        derecha <= '0';
        wait for wait_time;
        sw_c <= '0';        -- Sin cambio
        wait for wait_time;
        ma <= "1111";       -- Insertar 180
        wait for wait_time;
        mc <= '1';          -- Cargar dinero
        wait for wait_time;
        mc <= '0';          -- Detener carga de dinero
        wait for wait_time;

        -- Finalizar simulación
        wait;
    end process;

end behavior;
