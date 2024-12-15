library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entidad que nos permite cambiar el precio de refresco por medio de una maquina de estados
entity Precio is
    Port ( izq : in STD_LOGIC; --'1' cuando micro manda 'izquierda'='1'
           clk : in STD_LOGIC; --Señal de reloj
           der : in STD_LOGIC; --'1' cuando micro manda 'derecha'='1'
           pre : out std_logic_vector (1 downto 0); --Bits de precio que mandamos al micro
           p : inout STD_LOGIC_VECTOR (9 downto 0) --Precio del refresco
     );
end Precio;

architecture Behavioral of Precio is

-- Definición de estados posibles
type estados is(A,B,C);
signal presente, siguiente: estados;

begin

	--Estados y salidas
	process(der,izq,presente)
	begin
	case presente is 
				
		when A =>
			p <= "0001100100"; --precio=100
			if der='1' and izq='0' then
				siguiente <= B; --precio=530
		    elsif der='0' and izq='1' then
				siguiente <= C; --precio=280
			else
			    siguiente <= A; --precio=100
			end if;
		
		when B =>
			p <= "1000010010"; --precio=530
			if der='1' and izq='0' then
				siguiente <= C; --precio=280
		    elsif der='0' and izq='1' then
				siguiente <= A; --precio=100
			else
			    siguiente <= B; --precio=530
			end if;
			
		when C =>
			p <= "0100011000"; --precio=280
			if der='1' and izq='0' then
				siguiente <= A; --precio=100
		    elsif der='0' and izq='1' then
				siguiente <= B; --precio=530
			else
			    siguiente <= C;--precio=280
			end if;	
			
	end case;
	end process;
	
	--Estado 'presente' pasa a 'siguiente' en cada flanco de reloj
	process(clk)
	begin
		if rising_edge(clk) then
			presente <= siguiente;
		end if;
	end process;

    pre <= p(9 downto 8); --Asignación de los 2 bits más significativos del precio (p) 
end Behavioral;
