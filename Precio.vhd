library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Precio is
    Port ( izq : in STD_LOGIC;
           clk : in STD_LOGIC;
           der : in STD_LOGIC;
           p : out STD_LOGIC_VECTOR (9 downto 0));
end Precio;

architecture Behavioral of Precio is


type estados is(A,B,C);
signal presente, siguiente: estados;

begin

	--estados y salidas
	process(der,izq,presente)
	begin
	case presente is 
				
		when A =>
			p <= "0001100100";
			if der='1' and izq='0' then
				siguiente <= B;
		    elsif der='0' and izq='1' then
				siguiente <= C;
			else
			    siguiente <= A;
			end if;
		
		when B =>
			p <= "1000010010";
			if der='1' and izq='0' then
				siguiente <= C;
		    elsif der='0' and izq='1' then
				siguiente <= A;
			else
			    siguiente <= B;
			end if;
			
		when C =>
			p <= "0100011000";
			if der='1' and izq='0' then
				siguiente <= A;
		    elsif der='0' and izq='1' then
				siguiente <= B;
			else
			    siguiente <= C;
			end if;	
			
	end case;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			presente <= siguiente;
		end if;
	end process;


end Behavioral;
