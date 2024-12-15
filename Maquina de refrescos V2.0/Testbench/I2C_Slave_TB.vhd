library ieee;
use ieee.std_logic_1164.all;

entity I2C_SLV_tb is
end entity;

architecture arch of I2C_SLV_tb is

    -- Componente I2C_SLV (esclavo)
    component I2C_SLV is
        port(
            I2C_ADDRESS: in std_logic_vector(6 downto 0); -- Dirección del esclavo
            I2C_DATA: in std_logic_vector(7 downto 0);    -- Datos en el esclavo
            DATA_WRITE: out std_logic_vector(7 downto 0);  -- Datos que recibe el esclavo
            SCL: in std_logic;                             -- SCL = Serial Clock
            SDA : inout std_logic;                         -- SDA = Serial Data/Address
            SLV_BUSY : out std_logic                        -- 1 Busy, 0 Espera respuesta
        );
    end component;

    -- Señales de testbench
    signal I2C_ADDRESS : std_logic_vector(6 downto 0) := "0110001";  -- Dirección del esclavo
    signal I2C_DATA : std_logic_vector(7 downto 0) := "01111010";    -- Datos a recibir
    signal SDA : std_logic;
    signal SCL : std_logic;
    signal SLV_BUSY : std_logic := '1';
    signal DATA_WRITE : std_logic_vector(7 downto 0);

    -- Señales de control del maestro
    signal SENT_ADDRESS : std_logic_vector(6 downto 0) := "0110001"; -- Dirección enviada por el master
    signal SENT_DATA : std_logic_vector(7 downto 0) := "11010001";  -- Datos enviados por el master
    signal SENT_RW : std_logic := '0';  -- Bit de lectura/escritura (0 para escritura)
    signal DATA_MASTER : std_logic;

    constant period : time := 10 us;

begin

    -- Instancia del componente I2C_SLV (esclavo)
    UUT : I2C_SLV
        port map (
            I2C_ADDRESS => I2C_ADDRESS,  -- Dirección del esclavo
            I2C_DATA => I2C_DATA,        -- Datos que recibe el esclavo
            DATA_WRITE => DATA_WRITE,    -- Datos recibidos por el esclavo
            SCL => SCL,                  -- Reloj Serial
            SDA => SDA,                  -- Datos Seriales
            SLV_BUSY => SLV_BUSY        -- Estado del esclavo
        );

    -- Proceso de simulación del maestro
    process
    begin
        -- Secuencia de transmisión I2C del maestro (inicialización)
        wait for 2 * period;
        wait for (period / 2);
        SCL <= '1'; 
        DATA_MASTER <= '1';
        wait for (period / 2);
        
        -- Start bit
        DATA_MASTER <= '0';
        wait for (period / 2);
        SCL <= '0'; 
        wait for (period / 2);
        
        -- Enviar dirección (7 bits)
        for i in 0 to 6 loop
            DATA_MASTER <= SENT_ADDRESS(6 - i);
            wait for (period / 2);
            SCL <= '1'; 
            wait for (period / 2);
            SCL <= '0'; 
        end loop;

        -- Enviar bit RW (lectura o escritura)
        DATA_MASTER <= SENT_RW;
        wait for (period / 2);
        SCL <= '1'; 
        wait for (period / 2); -- Espera ACK
        SCL <= '0'; 
        wait for (period / 2);
        
        -- Recepción de datos (8 bits)
        for i in 0 to 7 loop
            DATA_MASTER <= SENT_DATA(7 - i);
            wait for (period / 2);
            SCL <= '1'; 
            wait for (period / 2);
            SCL <= '0'; 
        end loop;

        -- Fin de la transmisión
        wait for (period / 2);
        SCL <= '1'; 
        DATA_MASTER <= '1';
        if (SENT_RW = '1') then -- ACK si es lectura
            wait for (period / 2);
            SCL <= '0'; 
            wait for (period / 2);
            SCL <= '1'; 
        end if; 
        wait for (period / 2); -- Stop bit 
        SCL <= '0'; 
        wait for (period / 2);
        SCL <= '1'; 
        wait for (period * 2);
        
        -- Fin de la simulación
        wait;
    end process;

    -- Control de la línea SDA (Asegurarse de que no esté en alta impedancia si no es necesario)
    SDA <= DATA_MASTER when (SLV_BUSY = '0') else 'Z';  -- El maestro controla SDA cuando el esclavo está libre (SLV_BUSY = '0')

end arch;
