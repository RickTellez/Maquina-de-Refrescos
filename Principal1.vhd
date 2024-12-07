library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Principal1 is
	Port (  mc : in  STD_LOGIC;--Carga moneda
	        izquierda : in  STD_LOGIC; --Cambio de precio
	        derecha : in  STD_LOGIC; 
	        continue : in  STD_LOGIC; 
            md : out  STD_LOGIC; --Confirmacion carga moneda
            mclk : in  STD_LOGIC; --Master clock
            sw_c : in  STD_LOGIC; --1 Da cambio, 0 No da cambio
            leds : inout  STD_LOGIC_VECTOR (4 downto 0); --Leds error 
            reset : in  STD_LOGIC; --Reset
            ma : in  STD_LOGIC_VECTOR (3 downto 0); -- Cantidad ingresada
		    segmentos: out  STD_LOGIC_VECTOR (6 downto 0);
		    anodos: out  STD_LOGIC_VECTOR (7 downto 0));
end Principal1;

ARCHITECTURE dataflow OF Principal1 IS
    
    COMPONENT Tot
    PORT (
           ent : in  STD_LOGIC_VECTOR (9 downto 0);
           sal : out  STD_LOGIC_VECTOR (9 downto 0);
           load : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           clk : in  STD_LOGIC
    );
    END COMPONENT;
    
    COMPONENT Sumador8 is
	Port ( 
	       a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           suma : out  STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT Comparador8 is
	Port ( 
	       a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           e : out  STD_LOGIC;                      
           c : out  STD_LOGIC 
    );                     
    end COMPONENT;  
    
    COMPONENT Divisor is
	Port ( 
	  --     rst : in  STD_LOGIC;
		   clksal2 : out  STD_LOGIC;
           clksal : out  STD_LOGIC;
           clk : in  STD_LOGIC
    );
    end COMPONENT;  
    
    COMPONENT Cambio is
    Port ( 
           a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           Camb : inout  STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT Controlador is
	Port ( 
	       d : out  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sw_c : in  STD_LOGIC;
           continue : in  STD_LOGIC;
           tot_lt_s : in  STD_LOGIC;
           e : in  STD_LOGIC;
           leds : inout  STD_LOGIC_VECTOR (4 downto 0);
           leds2 : out  STD_LOGIC_VECTOR (4 downto 0);
           tot_ld : out  STD_LOGIC;
           tot_clr : out  STD_LOGIC;
           c : in  STD_LOGIC
    );
    end COMPONENT;
    
    COMPONENT Display is
    Port (
           a : in  STD_LOGIC_VECTOR (9 downto 0); 
           b : in  STD_LOGIC_VECTOR (9 downto 0); 
           an : out  STD_LOGIC_VECTOR (7 downto 0);
           p : in  STD_LOGIC_VECTOR (9 downto 0);
           clk : in  STD_LOGIC;
           leds : in  STD_LOGIC_VECTOR (4 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0)
    );
    end COMPONENT;
    
    COMPONENT Precio is
    Port ( 
           izq : in STD_LOGIC;
           clk : in STD_LOGIC;
           der : in STD_LOGIC;
           p : out STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT EDGEDTCTR is
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
    end COMPONENT;
    
    COMPONENT SYNCHRNZR is
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
    end COMPONENT;
 
    signal auxld, auxclr, auxclk, auxclk2, auxlt, auxe, auxmc, auxedgemc,auxizq,auxder,auxreset,auxizq2,auxder2,auxreset2 : STD_LOGIC;
    signal auxent, auxsal, auxprecio, auxcamb : STD_LOGIC_VECTOR (9 downto 0);
    signal auxleds : STD_LOGIC_VECTOR (4 downto 0);
    
    
    BEGIN
    
    Inst_Tot: Tot PORT MAP (
        ent => auxent,
        sal => auxsal,
        load => auxld,
        clr => auxclr,
        clk => auxclk 
    );
    Inst_Sumador8: Sumador8 PORT MAP (
        a => auxsal,
        b => ma,
        suma => auxent
    );
    Inst_Comparador8: Comparador8 PORT MAP (
        a => auxsal,
        b => auxprecio,
        e => auxe,
        c => auxlt
    );
    
    Inst_Divisor: Divisor PORT MAP (
--        rst => auxreset2,
	    clksal2 => auxclk2,
        clksal => auxclk,
        clk => mclk
    );
    
    Inst_Cambio: Cambio PORT MAP (
        a => auxsal,
        b => auxprecio,
        Camb => auxcamb
    );
    
    Inst_SYNCHRNZR: SYNCHRNZR PORT MAP (
        CLK => auxclk,
        MC_IN => izquierda,
        MC_OUT => auxizq,
        MC_IN2 => derecha,
        MC_OUT2 => auxder,
        MC_IN3 => mc,
        MC_OUT3 => auxmc,
        MC_IN4 => reset,
        MC_OUT4 => auxreset
    );
    
    Inst_EDGEDTCTR: EDGEDTCTR PORT MAP (
        CLK => auxclk,
        MCEDGE_IN => auxizq,
        MCEDGE_OUT => auxizq2,
        MCEDGE_IN2 => auxder,
        MCEDGE_OUT2 => auxder2,
        MCEDGE_IN3 => auxmc,
        MCEDGE_OUT3 => auxedgemc,
        MCEDGE_IN4 => auxreset,
        MCEDGE_OUT4 => auxreset2
    );
    
    Inst_Controlador: Controlador PORT MAP (
        d => md,
        rst => auxreset2,
        clk => auxclk,
        sw_c => sw_c,
        continue => continue, 
        tot_lt_s => auxlt,
        e => auxe,
        leds => leds,
        leds2 => auxleds,
        tot_ld => auxld,
        tot_clr => auxclr,
        c => auxedgemc
    );
    
    Inst_Display: Display PORT MAP (
        a => auxsal,
        b => auxcamb,
        an => anodos,
        p => auxprecio,
        leds => auxleds,
        clk => auxclk2,
        seg => segmentos
    );
    
    Inst_Precio: Precio PORT MAP (
        izq => auxizq2,
        clk => auxclk,
        der => auxder2,
        p => auxprecio
    );
    
    
END ARCHITECTURE dataflow;