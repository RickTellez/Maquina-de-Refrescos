library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Comparador8 is
	Port ( a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           e : out  STD_LOGIC;                      -- Error for cashless mode
           c : out  STD_LOGIC );                    -- Negates signal c (c='1' don´t give soda c='0' give soda)
			  
end Comparador8;

architecture Behavioral of Comparador8 is
begin

	process (a,b)
	begin
		if a<b then
			c<='1';
			e<='0';
		elsif a=b then 
			c<='0';
			e<='0';
		else 
		    c<='0';
		    e<='1';
		end if;
	end process;

end Behavioral;

