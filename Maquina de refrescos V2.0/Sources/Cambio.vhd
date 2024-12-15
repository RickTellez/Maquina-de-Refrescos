library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--Entidad compara si a>=b y devuelve el cambio (a-b)
entity Cambio is
    Port ( a : in  STD_LOGIC_VECTOR (9 downto 0); --Acumulado en Tot
           b : in  STD_LOGIC_VECTOR (9 downto 0); --Precio del refresco
           Camb : inout  STD_LOGIC_VECTOR (9 downto 0)); -- a-b (Sólo cuando a>=b)
end Cambio;



architecture Behavioral of Cambio is
 

begin

	process (a,b,Camb)
	begin
		if a<b then --Acumulado menor a costo de refresco
			Camb<="1111111111"; --Indica a Display que aun no alcanza para comprar el refresco 
			
		elsif a>=b then --Acumulado mayor o igual a costo de refresco
			Camb<=a-b; --Regresa el cambio
		else 
			Camb<="0000000000"; --Cuando a y b estan indefinidos 
			
		end if;
	end process;

	
end Behavioral;

