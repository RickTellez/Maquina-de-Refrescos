library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Sumador8 is
	Port ( a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           suma : out  STD_LOGIC_VECTOR (9 downto 0));
end Sumador8;

architecture Behavioral of Sumador8 is
signal c : std_logic_vector (9 downto 0);
begin
    
    c <= "0000000000" when b="0000" else --0
         "0000001010" when b="0001" else --10
         "0000010100" when b="0010" else --20
         "0000011110" when b="0011" else --30
         "0000110010" when b="0100" else --50
         "0000111100" when b="0101" else --60
         "0001000110" when b="0110" else --70
         "0001010000" when b="0111" else --80
         "0001100100" when b="1000" else --100
         "0001101110" when b="1001" else --110
         "0001111000" when b="1010" else --120
         "0010000010" when b="1011" else --130
         "0010010110" when b="1100" else --150
         "0010100000" when b="1101" else --160
         "0010101010" when b="1110" else --170
         "0010110100" when b="1111" else --180
         "UUUUUUUUUU";
    
	suma <= a+c;

end Behavioral;

