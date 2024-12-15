library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity Controlador is
	Port ( d : out  STD_LOGIC; --'1' entrega del refresco (led)
          clk : in  STD_LOGIC; --Señal de reloj
          rst : in  STD_LOGIC; --Reset
          continue : in  STD_LOGIC; --'1' Paso de despacha-->inicio o de error-->inicio
          sw_c : in  STD_LOGIC;  --1 Da cambio, 0 No da cambio
          tot_lt_s : in  STD_LOGIC; --'0' acumulado >= precio 
          e : in  STD_LOGIC; --'1' acumulado > precio y sw_c='0'
          leds : out  STD_LOGIC_VECTOR (4 downto 0); --"11111" Error cuando e='1'
          leds2 : out  STD_LOGIC_VECTOR (4 downto 0); --Error que lee Display
          tot_ld : out  STD_LOGIC; --Permite cargar a Tot lo sumado en Sumador
          tot_clr : out  STD_LOGIC; --Limpia lo acumulado en Tot
          c : in  STD_LOGIC --Permite cargar la moneda (estado suma) 
          );
end Controlador;

architecture Behavioral of Controlador is

--Estados posibles de la máquina de estados
type estados is(inicio, espera, suma, despacha,error);
signal presente, siguiente:estados;
signal ledsaux : std_logic_vector(4 downto 0):="00000"; --Leds de error

begin

	--Estados y salidas
	process(presente,c,tot_lt_s,sw_c,e,continue)
	begin
	case presente is 
	    --Estado de inicio: Inicializa las señales y pasa a 'espera'
		when inicio => 
			d <= '0'; --No se entrega refresco en el estado de inicio
			tot_clr <= '1'; --Se activa la limpieza del Tot
			tot_ld <= '0'; --No se cargan monedas en Tot
			siguiente <= espera; --incio --> espera
			
		--Estado de espera: Pasamos a otros estados o esperamos a señales externas
		when espera =>
			d <= '0'; --No se entrega refresco mientras estamos en espera
			tot_clr <= '0'; --No se activa la limpieza del Tot
			tot_ld <= '0'; --No se cargan monedas en Tot
			leds<= "00000"; --Se apagan los LEDs de error
			ledsaux <="00000"; --LEDs auxiliares apagados
			if rst ='0' then 
			    siguiente <= inicio;--Si se recibe un reset, volvemos al estado de inicio
			elsif c='1' then
				siguiente <= suma; --Si se carga una moneda, pasamos al estado de suma
			elsif (c='0' and tot_lt_s='1') then
				siguiente <= espera; --Si no se carga moneda y not(acumulado >= precio)
			elsif (c='0' and tot_lt_s='0') then --Si no se carga moneda y acumulado >= precio
			    if (sw_c='0' and e='1') then
				    siguiente <= error; --Pasamos al estado error, porque no damos cambio y acumulado > precio
				else -- sw_c=1 y acumulado >= precio ó sw_c='0' y acumulado = precio
				    siguiente <= despacha;
				end if;
			end if;
		
		-- Estado de error: Enciende LEDs (indica error) y espera 'continue' del micro
		when error => 
			leds<= "11111"; --LEDs se encienden para indicar error
			ledsaux <="11111"; --LEDs se encienden para indicar error para Display
			if continue ='1' then --Si microcontrolador manda 'continue'='1'
			     siguiente <= inicio;
			else 
			     siguiente <= error;  --No podemos pasar de error hasta la llegada de 'continue'  
			end if; 
		
		-- Estado de suma: El Tot se carga y pasa a 'espera'	
		when suma =>
			d <= '0'; --No se entrega refresco
			tot_clr <= '0'; --No se limpia el Tot
			tot_ld <= '1'; --Se carga el acumulado en Tot
			leds<= "00000"; --LEDs apagados
			ledsaux <="00000"; --LEDs apagados
			siguiente <= espera;
			
		-- Estado de despacha: Se entrega el refresco y espera 'continue' de microcontrolador
		when despacha =>
			d <= '1'; --Se entrega el refresco (se enciende el LED)
			tot_clr <= '0'; --No se limpia el Tot
			tot_ld <= '0'; --No se carga el acumulado en Tot
			leds<= "00000"; --LEDs apagados
			ledsaux <="00000"; --LEDs apagados
			if continue ='1' then --Solo podemos cambiar de estado si el controlador activa 'continue'
			     siguiente <= inicio; 
			else 
			     siguiente <= despacha;
			end if; 
		
		--Otros casos	
		when others => 
			d <= '0'; --No se entrega refresco
			tot_clr <= '1'; --Se limpia Tot
			tot_ld <= '0'; --Tot no carga lo acumulado
			
	end case;
	end process;
	
	--Se actualiza estado 'presente' en flanco de subida del reloj
	process(clk)
	begin
		if rising_edge(clk) then
			presente <= siguiente;
		end if;
	end process;

    leds2 <= ledsaux; --Leds que sirven para el control en entidad Display
    
end Behavioral;

