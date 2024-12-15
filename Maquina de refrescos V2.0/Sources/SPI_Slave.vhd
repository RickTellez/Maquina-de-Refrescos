library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--Entidad que nos permite recibir y trasmitir bytes con el micro (STM32F411E) por medio de comunicacion SPI 
entity SPI_Slave is
    Port ( 
           SCK    : in  std_logic;  -- Reloj SPI  -- JA1
           MOSI   : in  std_logic;  -- Datos de entrada SPI  --JA2
           MISO   : out std_logic;  -- Datos de salida SPI  --JA3
           SS     : in  std_logic;  -- Chip select  --JA4
           
           -- Entradas de la máquina de refrescos (valores a enviar al micro STM32)
           p : in STD_LOGIC_VECTOR(1 downto 0); --Precio del refresco
           leds : in  STD_LOGIC_VECTOR (4 downto 0); --Leds de error
           a : in STD_LOGIC_VECTOR(9 downto 0); --Monedas acumuladas 
           b : in STD_LOGIC_VECTOR(9 downto 0); --Cambio si acumulado >= precio 
    
           -- Salidas de la máquina de refrescos (enviados por el micro STM32)
           izquierda : out STD_LOGIC; --Cambiar al refresco de la izquierda
           derecha : out STD_LOGIC; --Cambiar al refresco de la derecha
           mc : out STD_LOGIC; --Confirmacion de la moneda 
           ma : out STD_LOGIC_VECTOR(3 downto 0); --Monedas ingresadas 
           continue : out STD_LOGIC --'1' error-->incio ó despacha-->incio
           
         );
end SPI_Slave;

architecture Behavioral of SPI_Slave is

    -- Señales internas
    signal send_bit_count : integer range 0 to 7 := 0;  --Contador de bits para la transmisión (MISO)
    signal byte_count : integer range 0 to 2 := 0;  --Contador de bytes para la transmisión (0 a 2 para 3 bytes)
    signal receive_bit_count : integer range 0 to 7 := 0;  --Contador de bits para la recepción (MOSI)
    signal byte_to_send : std_logic_vector(7 downto 0);  --Byte a enviar (MISO)
    signal Count_resta : integer range 0 to 7 := 7;  --Contador de 7 a 0 para los bits a enviar
    signal byte_received : std_logic_vector(7 downto 0) := (others => '0'); --Byte recibido
    signal send_bytes1 : std_logic_vector(7 downto 0); --Byte 1 a enviar
    signal send_bytes2 : std_logic_vector(7 downto 0); --Bytes 2 a enviar
    signal send_bytes3 : std_logic_vector(7 downto 0); --Bytes 3 a enviar

begin
    
    --Aqui asiganmos los valores que vamos a enviar al microcontrolador
    send_bytes1 <= a(9 downto 2); 
    send_bytes2 <= a(1 downto 0) & b(9 downto 4); 
    send_bytes3 <= b(3 downto 0) & p(1 downto 0) & leds(4) & '0'; 
    
    --Generación de MISO (Envío de 3 bytes)
    process (SCK, SS)
    begin
        if (SS = '0') then  --Cuando el chip select está activo (bajo)
            --Cargar el siguiente byte a enviar dependiendo del byte_count
                case byte_count is
                    when 0 => byte_to_send <= send_bytes1; --Primer byte
                    when 1 => byte_to_send <= send_bytes2;  --Segundo byte
                    when 2 => byte_to_send <= send_bytes3;   --Tercer byte
                    when others => byte_to_send <= (others => '0');     --Pasamos a primer byte
                end case;
                
            if rising_edge(SCK) then
            
                --Primero, asignamos el bit de byte_to_send basado en el contador Count_resta
                MISO <= byte_to_send(Count_resta);

                --Cuando lleguemos a 0, reiniciamos el contador de bits
                if Count_resta = 0 then
                    Count_resta <= 7;  --Reiniciar el contador
                    byte_count <= byte_count + 1;  --Pasamos al siguiente byte

                    --Cuando lleguemos al tercer byte, volvemos al primer byte
                    if byte_count = 2 then
                        byte_count <= 0;
                    end if;
                else
                    --Decrementar el contador para el siguiente bit
                    Count_resta <= Count_resta - 1;
                end if;
            end if;
        end if;
    end process;

    --Lectura de MOSI (Recepción de 1 byte)
    process (SCK, SS)
    begin
        if (SS = '0') then  --Cuando el chip select está activo ('0')
            if rising_edge(SCK) then
                --Desplazamos los bits recibidos en MOSI hacia la izquierda y agregamos el nuevo bit
                byte_received <= byte_received(6 downto 0) & MOSI;

                --Incrementamos el contador de bits para la recepción
                receive_bit_count <= receive_bit_count + 1;

                --Cuando lleguemos a 8 bits (un byte completo)
                if receive_bit_count = 7 then
                    --Reiniciar el contador de bits para la recepción
                    receive_bit_count <= 0;
                    
                    --Aqui asiganmos los valores que vamos a ocupar para la maquina de refrescos y que recibimos del micro
                    izquierda <= byte_received(7);
                    derecha <= byte_received(6);
                    mc <= byte_received(5);
                    ma <= byte_received(4 downto 1);
                    continue <= byte_received(0);
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
