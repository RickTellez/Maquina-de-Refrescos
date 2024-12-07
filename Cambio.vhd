library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Cambio is
    Port ( a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           Camb : inout  STD_LOGIC_VECTOR (9 downto 0));
end Cambio;



architecture Behavioral of Cambio is
 

begin

	process (a,b,Camb)
	begin
		if a<b then
			Camb<="1111111111";
			
		elsif a>=b then
			Camb<=a-b;
		else 
			Camb<="0000000000";
			
		end if;
	end process;

	
end Behavioral;

