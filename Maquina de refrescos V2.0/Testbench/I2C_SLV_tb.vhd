library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity I2C_SLV_tb is
end entity;

architecture behavioral of I2C_SLV_tb is
    -- Señales para la simulación
    signal i2c_clock : STD_LOGIC;
    signal i2c_reset : STD_LOGIC;
    signal i2c_trigger : STD_LOGIC;
    signal i2c_restart : STD_LOGIC;
    signal i2c_ack_error : STD_LOGIC;
    signal i2c_busy : STD_LOGIC;
    signal i2c_scl : STD_LOGIC;
    signal i2c_sda : STD_LOGIC;
    signal i2c_read_write : STD_LOGIC;
    signal i2c_address : STD_LOGIC_VECTOR(6 downto 0);

    -- Señales de la máquina de refrescos (entradas y salidas)
    signal i2c_p : STD_LOGIC_VECTOR(1 downto 0);
    signal i2c_leds : STD_LOGIC_VECTOR(4 downto 0);
    signal i2c_a : STD_LOGIC_VECTOR(9 downto 0);
    signal i2c_b : STD_LOGIC_VECTOR(9 downto 0);
    signal i2c_izquierda : STD_LOGIC;
    signal i2c_derecha : STD_LOGIC;
    signal i2c_mc : STD_LOGIC;
    signal i2c_ma : STD_LOGIC_VECTOR(3 downto 0);
    signal i2c_continue : STD_LOGIC;
begin
    -- Instanciar la unidad bajo prueba (DUT)
    dut: entity work.I2C_SLV port map (
        clock => i2c_clock,
        reset => i2c_reset,
        trigger => i2c_trigger,
        restart => i2c_restart,
        ack_error => i2c_ack_error,
        busy => i2c_busy,
        scl => i2c_scl,
        sda => i2c_sda,
        p => i2c_p,
        leds => i2c_leds,
        a => i2c_a,
        b => i2c_b,
        izquierda => i2c_izquierda,
        derecha => i2c_derecha,
        mc => i2c_mc,
        ma => i2c_ma,
        continue => i2c_continue,
        read_write => i2c_read_write
    );

    -- Generación del reloj de 100kHz (i2c_clock)
    process
    begin
        i2c_clock <= '0';
        wait for 1 ns;
        i2c_clock <= '1';
        wait for 1 ns;
    end process;

	process
	begin
		-- Resetea la secuencia
		i2c_reset <= '1';
		i2c_trigger <= '0';
		i2c_restart <= '0';
		i2c_p <= "00";         -- Valores iniciales para p
        i2c_leds <= "00000";    -- Valores iniciales para leds
        i2c_a <= "0000000000";  -- Valores iniciales para a
        i2c_b <= "0000000000";  -- Valores iniciales para b
		wait for 2 ns;

		-- EScribimos 3 bytes
		i2c_reset <= '0';
		i2c_address <= "0000010";
		i2c_read_write <= '0';
		i2c_a <= "0011111100";
		i2c_b <= "0011111100";
		i2c_leds <= "10101";
		i2c_p <= "11";
		
		-- Escribir direccion slave
		i2c_trigger <= '1';
		wait for 8 ns;
		i2c_trigger <= '0';

		wait until (i2c_busy = '0');
		wait for 2 us;

        -- Escribir el  byte 1
        i2c_trigger <= '1';      -- Activa el trigger para el tercer byte
        wait for 8 ns;
        i2c_trigger <= '0';      -- Desactiva el trigger
        
        wait until (i2c_busy = '0');
		wait for 2 us;
		
		-- Escribir el  byte 2
        i2c_trigger <= '1';      -- Activa el trigger para el tercer byte
        wait for 8 ns;
        i2c_trigger <= '0';      -- Desactiva el trigger
        
        wait until (i2c_busy = '0');
		wait for 2 us;
		
		-- Escribir el  byte 3
        i2c_trigger <= '1';      -- Activa el trigger para el tercer byte
        wait for 8 ns;
        i2c_trigger <= '0';      -- Desactiva el trigger
        
        wait until (i2c_busy = '0');
		wait for 2 us;
		
		-- Lectura despues de restart
		i2c_read_write <= '1';
		-- Escribir direccion slave
		i2c_trigger <= '1';
		i2c_restart <= '1';
		wait for 2 ns;
		i2c_trigger <= '0';
		i2c_restart <= '0';

		wait until (i2c_busy = '0');
		wait for 1 us;
        
        --Lectura de byte 1 
		i2c_trigger <= '1';
		wait for 8 ns;
		i2c_trigger <= '0';

		wait until (i2c_busy = '0');
		wait for 1 us;

		report "Terminado";

	end process;


end architecture;
