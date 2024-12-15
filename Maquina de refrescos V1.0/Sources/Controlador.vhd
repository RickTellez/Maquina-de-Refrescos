library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controlador is
	Port ( d : out  STD_LOGIC;
          clk : in  STD_LOGIC;
          rst : in  STD_LOGIC;
          continue : in  STD_LOGIC; 
          sw_c : in  STD_LOGIC;
          tot_lt_s : in  STD_LOGIC;
          e : in  STD_LOGIC;
          leds : inout  STD_LOGIC_VECTOR (4 downto 0);
          leds2 : out  STD_LOGIC_VECTOR (4 downto 0);
          tot_ld : out  STD_LOGIC;
          tot_clr : out  STD_LOGIC;
          c : in  STD_LOGIC);
end Controlador;

architecture Behavioral of Controlador is

type estados is(inicio, espera, suma, despacha,error);
signal presente, siguiente:estados;

begin

	--estados y salidad
	process(presente,c,tot_lt_s,sw_c,e,continue)
	begin
	case presente is 
		when inicio => 
			d <= '0';
			tot_clr <= '1';
			tot_ld <= '0';
			siguiente <= espera;
			
		when espera =>
			d <= '0';
			tot_clr <= '0';
			tot_ld <= '0';
			leds<= "00000"; 
			if rst ='1' then 
			    siguiente <= inicio;
			elsif c='1' then
				siguiente <= suma;
			elsif (c='0' and tot_lt_s='1') then
				siguiente <= espera;
			elsif (c='0' and tot_lt_s='0') then
			    if (sw_c='0' and e='1') then
				    siguiente <= error;
				else
				    siguiente <= despacha;
				end if;
--			elsif (c='0' and tot_lt_s='0'and e='1'and sw_c='0') then
--				siguiente <= error;
			end if;
		
		when error => 
			leds<= "11111";
			if continue ='1' then 
			     siguiente <= inicio;
			else 
			     siguiente <= error;    
			end if; 
			
		when suma =>
			d <= '0';
			tot_clr <= '0';
			tot_ld <= '1';
			leds<= "00000"; 
			siguiente <= espera;
			
		when despacha =>
			d <= '1'; -- entrega refresco
			tot_clr <= '0';
			tot_ld <= '0';
			leds<= "00000"; 
			if continue ='1' then
			     siguiente <= inicio;
			else 
			     siguiente <= despacha;
			end if; 
			
		when others => 
			d <= '0';
			tot_clr <= '1';
			tot_ld <= '0';
			
	end case;
	end process;
	leds2 <= leds;
	process(clk)
	begin
		if rising_edge(clk) then
			presente <= siguiente;
		end if;
	end process;

end Behavioral;

