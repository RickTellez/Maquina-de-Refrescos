library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
port (
    CLK : in std_logic;
    MC_IN : in std_logic;
    MC_OUT : out std_logic;
    MC_IN2 : in std_logic;
    MC_OUT2 : out std_logic;
    MC_IN3 : in std_logic;
    MC_OUT3 : out std_logic;
    MC_IN4 : in std_logic;
    MC_OUT4 : out std_logic
);
end SYNCHRNZR;
architecture BEHAVIORAL of SYNCHRNZR is

signal sreg : std_logic_vector(1 downto 0);
signal aux_rst : std_logic_vector(1 downto 0);
signal sreg2 : std_logic_vector(1 downto 0);
signal aux_rst2 : std_logic_vector(1 downto 0);
signal sreg3 : std_logic_vector(1 downto 0);
signal aux_rst3 : std_logic_vector(1 downto 0);
signal sreg4 : std_logic_vector(1 downto 0);
signal aux_rst4 : std_logic_vector(1 downto 0);

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            MC_OUT <= sreg(1);
            sreg <= sreg(0) & MC_IN;
            MC_OUT2 <= sreg2(1);
            sreg2 <= sreg2(0) & MC_IN2;
            MC_OUT3 <= sreg3(1);
            sreg3 <= sreg3(0) & MC_IN3;
            MC_OUT4 <= sreg4(1);
            sreg4 <= sreg4(0) & MC_IN4;
        end if;
    end process;
end BEHAVIORAL;
