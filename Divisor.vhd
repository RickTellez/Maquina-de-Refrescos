library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Divisor is
    Port (-- rst : in  STD_LOGIC;
           clksal2 : out  STD_LOGIC;
           clksal : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end Divisor;

architecture Behavioral of Divisor is
    signal f: unsigned(23 downto 0) := (others => '0'); -- Contador como unsigned
begin

    process(clk )
    begin
   --     if rst = '1' then
          --  f <= (others => '0'); -- Resetear contador
        if rising_edge(clk) then
            f <= f + 1; -- Incrementar contador
        end if;
    end process;

    clksal2 <= f(15); -- 15 Salida 2´4,  100MHz/16= 6.25MHz  Para simular f(4),f(1)
    clksal <= f(23); -- 23 Salida 2´1,  100MHz/2= 50MHz

end Behavioral;