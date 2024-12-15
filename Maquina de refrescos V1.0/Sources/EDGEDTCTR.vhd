library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
port (
    CLK : in std_logic;
    MCEDGE_IN : in std_logic;
    MCEDGE_OUT : out std_logic;
    MCEDGE_IN2 : in std_logic;
    MCEDGE_OUT2 : out std_logic;
    MCEDGE_IN3 : in std_logic;
    MCEDGE_OUT3 : out std_logic;
    MCEDGE_IN4 : in std_logic;
    MCEDGE_OUT4 : out std_logic
);
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is

signal sreg : std_logic_vector(2 downto 0);
signal sreg2 : std_logic_vector(2 downto 0);
signal sreg3 : std_logic_vector(2 downto 0);
signal sreg4 : std_logic_vector(2 downto 0);

begin
    process (CLK)
        begin
        if rising_edge(CLK) then
            sreg <= sreg(1 downto 0) & MCEDGE_IN;
            sreg2 <= sreg2(1 downto 0) & MCEDGE_IN2;
            sreg3 <= sreg3(1 downto 0) & MCEDGE_IN3;
            sreg4 <= sreg4(1 downto 0) & MCEDGE_IN4;
        end if;
    end process;
    with sreg select
        MCEDGE_OUT <= '1' when "100",
                '0' when others;
    with sreg2 select
        MCEDGE_OUT2 <= '1' when "100",
                '0' when others;
    with sreg3 select
        MCEDGE_OUT3 <= '1' when "100",
                '0' when others;
    with sreg4 select
        MCEDGE_OUT4 <= '1' when "100",
                '0' when others;
end BEHAVIORAL;