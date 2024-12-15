library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entidad que sincroniza varias señales de entrada con el reloj de sistema
entity SYNCHRNZR is
port (
    CLK : in std_logic; --Señal de reloj 
    MC_IN : in std_logic; --Izquierda
    MC_OUT : out std_logic; --Izquierda sicronizada 
    MC_IN2 : in std_logic; --Derecha 
    MC_OUT2 : out std_logic; --Derecha sincronizada
    MC_IN3 : in std_logic; --mc (Confirmacion de moneda)
    MC_OUT3 : out std_logic; --mc sincronizada
    MC_IN4 : in std_logic; --reset 
    MC_OUT4 : out std_logic; --reset sincronizado 
    MC_IN5 : in std_logic; --Continue
    MC_OUT5 : out std_logic --Continue sincronizado
);
end SYNCHRNZR;
architecture BEHAVIORAL of SYNCHRNZR is

--Señales para recorrer la señal de entrada en los registros 
signal sreg : std_logic_vector(1 downto 0);
signal aux_rst : std_logic_vector(1 downto 0);
signal sreg2 : std_logic_vector(1 downto 0);
signal aux_rst2 : std_logic_vector(1 downto 0);
signal sreg3 : std_logic_vector(1 downto 0);
signal aux_rst3 : std_logic_vector(1 downto 0);
signal sreg4 : std_logic_vector(1 downto 0);
signal aux_rst4 : std_logic_vector(1 downto 0);
signal sreg5 : std_logic_vector(1 downto 0);
signal aux_rst5 : std_logic_vector(1 downto 0);

begin
    process (CLK)
    begin
        --Obtenemos la señal de entrada a la salida despues de 3 ciclos de reloj 
        if rising_edge(CLK) then
            MC_OUT <= sreg(1);
            sreg <= sreg(0) & MC_IN;
            MC_OUT2 <= sreg2(1);
            sreg2 <= sreg2(0) & MC_IN2;
            MC_OUT3 <= sreg3(1);
            sreg3 <= sreg3(0) & MC_IN3;
            MC_OUT4 <= sreg4(1);
            sreg4 <= sreg4(0) & MC_IN4;
            MC_OUT5 <= sreg5(1);
            sreg5 <= sreg5(0) & MC_IN5;
        end if;
    end process;
end BEHAVIORAL;
