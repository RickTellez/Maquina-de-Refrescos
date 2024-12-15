library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidad de registro de 10 bits. Carga, limpia o actualiza datos
entity Tot is
	Port ( ent : in  STD_LOGIC_VECTOR (9 downto 0); --Entrada registro
           sal : out  STD_LOGIC_VECTOR (9 downto 0);  --Salida registro
           load : in  STD_LOGIC; -- '1' Carga valores
           clr : in  STD_LOGIC; -- '1' limpia valores
           clk : in  STD_LOGIC); -- señal de reloj
end Tot;

architecture Behavioral of Tot is

begin

process (clk,load,clr)
	begin
		if clr='1' then
			sal <= "0000000000"; -- Reinicia la salida a 0
		elsif rising_edge(clk) then
			if load='1' then 
				sal <= ent; --Carga el valor de entrada en salida
			end if;
		end if;
	end process;
	
end Behavioral;

