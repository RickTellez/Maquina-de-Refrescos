library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Slave_tb is

end SPI_Slave_tb;

architecture Behavioral of SPI_Slave_tb is

	component SPI_Slave is 
    port (
           SCK    : in  std_logic;  -- Reloj SPI  -- JA1
           MOSI   : in  std_logic;  -- Datos de entrada SPI  --JA2
           MISO   : out std_logic;  -- Datos de salida SPI  --JA3
           SS     : in  std_logic;  -- Chip select  --JA4
           
           -- Entradas de la máquina de refrescos (valores a enviar)
           p : in STD_LOGIC_VECTOR(1 downto 0); --Precio del refresco
           leds : in  STD_LOGIC_VECTOR (4 downto 0); --Leds de error
           a : in STD_LOGIC_VECTOR(9 downto 0); --Monedas acumuladas
           b : in STD_LOGIC_VECTOR(9 downto 0); --Cambio si acumulado >= precio
    
           -- Salidas de la máquina de refrescos (recibidos desde el STM32)
           izquierda : out STD_LOGIC; --Cambiar al refresco de la izquierda
           derecha : out STD_LOGIC; --Cambiar al refresco de la derecha
           mc : out STD_LOGIC; --Confirmación de la moneda
           ma : out STD_LOGIC_VECTOR(3 downto 0); --Monedas ingresadas
           continue : out STD_LOGIC --'1' error-->inicio ó despacha-->inicio
    );
    end component SPI_Slave; 
    
    --Señales para conectar la entidad con el testbench
    signal sck, mosi, ss :  std_logic;
    signal miso :  std_logic;
    signal p : std_logic_vector(1 downto 0);
    signal leds :  std_logic_vector (4 downto 0);
    signal a : std_logic_vector(9 downto 0);
    signal b : std_logic_vector(9 downto 0);
    signal izquierda, derecha, mc, continue : std_logic;
    signal ma : std_logic_vector(3 downto 0);

	
	--Constante para el periodo del reloj
	constant CLK_PERIOD : time := 10 us;

begin 
    
    --Inicialización de las señales de entrada
     a <="0000001010"; --10 centimos acumuladas
     b <="0000000000"; --Sin cambio
     p <="01"; --Precio del refresco
     leds <="00000"; --Sin error
   
   --Instanciamos la entidad SPI_Slave
    utt: SPI_Slave 
    port map(
            
            SCK => sck,
            MOSI => mosi,
            MISO => miso,
            SS => ss, 
            p => p,
            leds => leds,
            a => a,
            b => b,
            izquierda => izquierda,
            derecha => derecha,
            mc => mc,
            ma => ma,
            continue => continue
    );
        
    --Generacion del reloj SCK para comunicacion SPI    
    clk_process: process
    begin
        while true loop
            sck <= '0';
            wait for CLK_PERIOD / 2; --Esperamos medio periodo
            sck <= '1';
            wait for CLK_PERIOD / 2; --Esperamos medio periodo
        end loop;
    end process;
     
    process 
    begin 
        ss <= '1';  --Desactivar chip select
        wait for CLK_PERIOD / 8;
        ss <= '0'; --Activar chip select
        wait for CLK_PERIOD / 4;
        --A partir de aqui simulamos leer el byte que nos manda el micro
        mosi <= '1';
        wait for CLK_PERIOD ;
        mosi <= '0';
        wait for CLK_PERIOD ;
        mosi <= '1';
        wait for CLK_PERIOD ;
        mosi <= '0';
        wait for CLK_PERIOD ;
        mosi <= '1';
        wait for CLK_PERIOD ;
        mosi <= '0';
        wait for CLK_PERIOD ;
        mosi <= '1';
        wait for CLK_PERIOD ;
        mosi <= '0';
        wait for 300us; --Tiempo suficiente para que nosotros enviemos 3 bytes
        assert false
        report "[PASSED]: simulation finished" --Mensaje: "Fin de simulacion"
        severity failure;
    end process; 

end Behavioral;
