library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tot is
	Port ( ent : in  STD_LOGIC_VECTOR (9 downto 0);
           sal : out  STD_LOGIC_VECTOR (9 downto 0);
           load : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end Tot;

architecture Behavioral of Tot is

begin

process (clk,load,clr)
	begin
		if clr='1' then
			sal <= "0000000000";
		elsif rising_edge(clk) then
			if load='1' then
				sal <= ent;
			end if;
		end if;
	end process;
	
end Behavioral;

