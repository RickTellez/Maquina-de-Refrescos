library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

--Entidad para detectar los cambios de flanco en las señales de entrada
entity EDGEDTCTR is
port (
    CLK : in std_logic;
    MCEDGE_IN : in std_logic; --Izquierda sicronizada 
    MCEDGE_OUT : out std_logic; --Izquierda sicronizada y cte
    MCEDGE_IN2 : in std_logic; --Derecha sincronizada
    MCEDGE_OUT2 : out std_logic; --Derecha sincronizada y cte
    MCEDGE_IN3 : in std_logic; --mc sincronizada
    MCEDGE_OUT3 : out std_logic; --mc sincronizada y cte
    MCEDGE_IN4 : in std_logic; --reset sincronizado 
    MCEDGE_OUT4 : out std_logic; --reset sincronizado y cte
    MCEDGE_IN5 : in std_logic; --Continue sincronizado
    MCEDGE_OUT5 : out std_logic --Continue sincronizado y cte
);
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is

--Registros de 3 bits para almacenar el estado de las señales de entrada
signal sreg : std_logic_vector(2 downto 0);
signal sreg2 : std_logic_vector(2 downto 0);
signal sreg3 : std_logic_vector(2 downto 0);
signal sreg4 : std_logic_vector(2 downto 0);
signal sreg5 : std_logic_vector(2 downto 0);

begin
    process (CLK)
        begin
        if rising_edge(CLK) then
            --Se actualizan los registros con las señales de entrada
            sreg <= sreg(1 downto 0) & MCEDGE_IN;
            sreg2 <= sreg2(1 downto 0) & MCEDGE_IN2;
            sreg3 <= sreg3(1 downto 0) & MCEDGE_IN3;
            sreg4 <= sreg4(1 downto 0) & MCEDGE_IN4;
            sreg5 <= sreg5(1 downto 0) & MCEDGE_IN5;
        end if;
    end process;
    
    --Detección de flanco ascendente: se activa la salida cuando el valor del registro es "100"
    with sreg select
        MCEDGE_OUT <= '1' when "100",
                '0' when others;  --En cualquier otro caso, no hay flanco
    with sreg2 select
        MCEDGE_OUT2 <= '1' when "100",
                '0' when others;
    with sreg3 select
        MCEDGE_OUT3 <= '1' when "100",
                '0' when others;
    with sreg4 select
        MCEDGE_OUT4 <= '1' when "100",
                '0' when others;
    with sreg5 select
        MCEDGE_OUT5 <= '1' when "100",
                '0' when others;
end BEHAVIORAL;