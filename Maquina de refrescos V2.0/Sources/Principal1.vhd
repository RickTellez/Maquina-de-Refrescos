library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Principal1 is
	Port (  SCK    : in  std_logic;  -- Reloj SPI
            MOSI   : in  std_logic;  -- Datos de entrada SPI
            MISO   : out std_logic;  -- Datos de salida SPI
            SS     : in  std_logic;  -- Chip select
            md : out  STD_LOGIC; --Confirmacion refreco despachado (LED)
            mclk : in  STD_LOGIC; --Master clock (100MHz)
            sw_c : in  STD_LOGIC; --1 Da cambio, 0 No da cambio
            leds : out  STD_LOGIC_VECTOR (4 downto 0); --Leds error 
            reset : in  STD_LOGIC; --Reset
		    segmentos: out  STD_LOGIC_VECTOR (6 downto 0); --Display de 7 segmentos
		    anodos: out  STD_LOGIC_VECTOR (7 downto 0)); --Anodos para 8 displays
end Principal1;

ARCHITECTURE dataflow OF Principal1 IS
    
    COMPONENT Tot --Creamos entradas y salidas de entidad Tot
    PORT (
           ent : in  STD_LOGIC_VECTOR (9 downto 0);
           sal : out  STD_LOGIC_VECTOR (9 downto 0);
           load : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           clk : in  STD_LOGIC
    );
    END COMPONENT;
    
    COMPONENT Sumador8 is --Creamos entradas y salidas de entidad Sumador
	Port ( 
	       a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (3 downto 0);
           suma : out  STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT Comparador8 is --Creamos entradas y salidas de entidad Comparador
	Port ( 
	       a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           e : out  STD_LOGIC;                      
           c : out  STD_LOGIC 
    );                     
    end COMPONENT;  
    
    COMPONENT Divisor is --Creamos entradas y salidas de entidad Divisor de frecuencias
	Port ( 
	  --     rst : in  STD_LOGIC;
		   clksal2 : out  STD_LOGIC;
           clksal : out  STD_LOGIC;
           clk : in  STD_LOGIC
    );
    end COMPONENT;  
    
    COMPONENT Cambio is --Creamos entradas y salidas de entidad Cambio
    Port ( 
           a : in  STD_LOGIC_VECTOR (9 downto 0);
           b : in  STD_LOGIC_VECTOR (9 downto 0);
           Camb : inout  STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT Controlador is --Creamos entradas y salidas de entidad Controlador
	Port ( 
	       d : out  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sw_c : in  STD_LOGIC;
           continue : in  STD_LOGIC;
           tot_lt_s : in  STD_LOGIC;
           e : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (4 downto 0);
           leds2 : out  STD_LOGIC_VECTOR (4 downto 0);
           tot_ld : out  STD_LOGIC;
           tot_clr : out  STD_LOGIC;
           c : in  STD_LOGIC
    );
    end COMPONENT;
    
    COMPONENT Display is --Creamos entradas y salidas de entidad Display
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
    
    COMPONENT Precio is --Creamos entradas y salidas de entidad Precio
    Port ( 
           izq : in STD_LOGIC;
           clk : in STD_LOGIC;
           der : in STD_LOGIC;
           pre : out std_logic_vector (1 downto 0);
           p : inout STD_LOGIC_VECTOR (9 downto 0)
    );
    end COMPONENT;
    
    COMPONENT EDGEDTCTR is --Creamos entradas y salidas de entidad EDGEDTCTR
    port (
           CLK : in std_logic;
           MCEDGE_IN : in std_logic;
           MCEDGE_OUT : out std_logic;
           MCEDGE_IN2 : in std_logic;
           MCEDGE_OUT2 : out std_logic;
           MCEDGE_IN3 : in std_logic;
           MCEDGE_OUT3 : out std_logic;
           MCEDGE_IN4 : in std_logic;
           MCEDGE_OUT4 : out std_logic;
           MCEDGE_IN5 : in std_logic;
           MCEDGE_OUT5 : out std_logic
    );
    end COMPONENT;
    
    COMPONENT SYNCHRNZR is --Creamos entradas y salidas de entidad SYNCHRNZR
    port (
           CLK : in std_logic;
           MC_IN : in std_logic;
           MC_OUT : out std_logic;
           MC_IN2 : in std_logic;
           MC_OUT2 : out std_logic;
           MC_IN3 : in std_logic;
           MC_OUT3 : out std_logic;
           MC_IN4 : in std_logic;
           MC_OUT4 : out std_logic; 
           MC_IN5 : in std_logic;
           MC_OUT5 : out std_logic 
    );
    end COMPONENT;
    
    COMPONENT SPI_Slave --Creamos entradas y salidas de entidad SPI_Slave
    PORT (
        SCK    : in  std_logic;  -- Reloj SPI
        MOSI   : in  std_logic;  -- Datos de entrada SPI
        MISO   : out std_logic;  -- Datos de salida SPI
        SS     : in  std_logic;  -- Chip select
        p : in STD_LOGIC_VECTOR(1 downto 0);
        leds : in  STD_LOGIC_VECTOR (4 downto 0);
        a : in STD_LOGIC_VECTOR(9 downto 0);
        b : in STD_LOGIC_VECTOR(9 downto 0);
        izquierda : out STD_LOGIC;
        derecha : out STD_LOGIC;
        mc : out STD_LOGIC;
        ma : out STD_LOGIC_VECTOR(3 downto 0);
        continue : out STD_LOGIC
    );
    END COMPONENT;
    
    -- Señales auxiliares para comunicar entidades de la maquina de refrescos 
    signal auxld, auxclr, auxclk, auxclk2, auxlt, auxe, auxmc, auxedgemc,auxizq : STD_LOGIC;
    signal auxder,auxreset,auxizq2,auxder2,auxreset2,auxcontinue,auxcontinue2 : STD_LOGIC;
    signal izquierda, derecha, mc, continue : STD_LOGIC;
    signal auxpre : STD_LOGIC_VECTOR(1 downto 0);
    signal ma : STD_LOGIC_VECTOR(3 downto 0);
    signal auxent, auxsal, auxprecio, auxcamb : STD_LOGIC_VECTOR (9 downto 0);
    signal auxleds : STD_LOGIC_VECTOR (4 downto 0);
    
    
    BEGIN
    
    --Instanciamos entidad Tot, y conectamos I/O con señales auxiliares
    Inst_Tot: Tot PORT MAP ( 
        ent => auxent,
        sal => auxsal,
        load => auxld,
        clr => auxclr,
        clk => auxclk 
    );
    --Instanciamos entidad Sumador, y conectamos I/O con señales auxiliares
    Inst_Sumador8: Sumador8 PORT MAP ( 
        a => auxsal,
        b => ma,
        suma => auxent
    );
    --Instanciamos entidad Comparador, y conectamos I/O con señales auxiliares
    Inst_Comparador8: Comparador8 PORT MAP (
        a => auxsal,
        b => auxprecio,
        e => auxe,
        c => auxlt
    );
    --Instanciamos entidad Divisor, y conectamos I/O con señales auxiliares
    Inst_Divisor: Divisor PORT MAP (
	    clksal2 => auxclk2,
        clksal => auxclk,
        clk => mclk
    );
    --Instanciamos entidad Cambio, y conectamos I/O con señales auxiliares
    Inst_Cambio: Cambio PORT MAP (
        a => auxsal,
        b => auxprecio,
        Camb => auxcamb
    );
    --Instanciamos entidad SYNCHRONZR, y conectamos I/O con señales auxiliares
    Inst_SYNCHRNZR: SYNCHRNZR PORT MAP (
        CLK => auxclk,
        MC_IN => izquierda,
        MC_OUT => auxizq,
        MC_IN2 => derecha,
        MC_OUT2 => auxder,
        MC_IN3 => mc,
        MC_OUT3 => auxmc,
        MC_IN4 => reset,
        MC_OUT4 => auxreset,
        MC_IN5 => continue,
        MC_OUT5 => auxcontinue
    );
    --Instanciamos entidad EDGEDTCTR, y conectamos I/O con señales auxiliares
    Inst_EDGEDTCTR: EDGEDTCTR PORT MAP (
        CLK => auxclk,
        MCEDGE_IN => auxizq,
        MCEDGE_OUT => auxizq2,
        MCEDGE_IN2 => auxder,
        MCEDGE_OUT2 => auxder2,
        MCEDGE_IN3 => auxmc,
        MCEDGE_OUT3 => auxedgemc,
        MCEDGE_IN4 => auxreset,
        MCEDGE_OUT4 => auxreset2,
        MCEDGE_IN5 => auxcontinue,
        MCEDGE_OUT5 => auxcontinue2
    );
    --Instanciamos entidad Controlador, y conectamos I/O con señales auxiliares
    Inst_Controlador: Controlador PORT MAP (
        d => md,
        rst => auxreset2,
        clk => auxclk,
        sw_c => sw_c,
        continue => auxcontinue2, 
        tot_lt_s => auxlt,
        e => auxe,
        leds => leds,
        leds2 => auxleds,
        tot_ld => auxld,
        tot_clr => auxclr,
        c => auxedgemc
    );
    --Instanciamos entidad Display, y conectamos I/O con señales auxiliares
    Inst_Display: Display PORT MAP (
        a => auxsal,
        b => auxcamb,
        an => anodos,
        p => auxprecio,
        leds => auxleds,
        clk => auxclk2,
        seg => segmentos
    );
    --Instanciamos entidad Precio, y conectamos I/O con señales auxiliares
    Inst_Precio: Precio PORT MAP (
        izq => auxizq2,
        clk => auxclk,
        der => auxder2,
        pre => auxpre,
        p => auxprecio
    );
    --Instanciamos entidad SPI_Slave, y conectamos I/O con señales auxiliares
    Inst_SPI_Slave : SPI_Slave  PORT MAP (
        SCK => SCK,
        MOSI => MOSI,
        MISO => MISO,
        SS => SS,
        p => auxpre,
        leds => auxleds,
        a => auxsal,
        b => auxcamb,
        izquierda => izquierda ,
        derecha => derecha ,
        mc => mc ,
        ma => ma,
        continue => continue
    );
    
    
END ARCHITECTURE dataflow;