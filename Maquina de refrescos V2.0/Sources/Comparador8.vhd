library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

--Entidad para compara dinero acumulado en Tot y precio de refresco
entity Comparador8 is
	Port ( a : in  STD_LOGIC_VECTOR (9 downto 0); --Dinero acumulado en Tot
           b : in  STD_LOGIC_VECTOR (9 downto 0); --Precio del refresco
           e : out  STD_LOGIC; --Error '1' cuando sw_c='0' y a>b                  
           c : out  STD_LOGIC -- '0' cuando a >= b
          );                  
			  
end Comparador8;

architecture Behavioral of Comparador8 is
begin
    
    
	process (a,b)
	begin
		if a<b then --Acumulado menor a precio refresco
			c<='1';
			e<='0';
		elsif a=b then --Acumulado igual a precio refresco
			c<='0';
			e<='0';
		else --Acumulado mayor a precio refresco
		    c<='0';
		    e<='1';
		end if;
	end process;

end Behavioral;

