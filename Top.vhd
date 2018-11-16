library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Top is
    Port ( 
    CLK : in std_logic;
    reset_top : in std_logic;
    uart_in : in std_logic;
    erreur_top : out std_logic;
    
    UART_RXD_OUT : out std_logic;
    an : out std_logic_vector( 7 downto 0);
    ca, cb, cc, cd, ce, cf, cg, dp : out std_logic
    
    );
end Top;

architecture Behavioral of Top is

component diviseur is
 Generic (
    w : integer
    );
 Port (
    CLK100MHZ, reset : in std_logic;
    sortieLed : out std_logic
    );
end component diviseur;

component StateMachine is
Port(
    uart : in std_logic;
    CLK100MHZ, clkDiviseur, reset : in std_logic;
    error : out std_logic;
    --diviseurReset : out std_logic;
    donnee : out std_logic_vector (7 downto 0)
);
end component StateMachine;

component aff7seg is
port (
        clk100mhz : in std_logic;
        heures_1,   heures_2    : in std_logic_vector(7 downto 0);
        minutes_1,  minutes_2   : in std_logic_vector(7 downto 0);
        secondes_1, secondes_2  : in std_logic_vector(7 downto 0);
        centiemes_1,centiemes_2 : in std_logic_vector(7 downto 0);
        an : out std_logic_vector(7 downto 0);
        ca, cb, cc, cd, ce, cf, cg, dp : out std_logic
    );
end component aff7seg;


signal donnee_recu : std_logic_vector (7 downto 0);
signal diviseurCLK1 : std_logic;
signal diviseurCLK2 : std_logic;
signal sa, sb, sc, sd, se, sf, sg, sp : std_logic_vector (7 downto 0) := "0000000";

begin

diviseurCLK2 <= diviseurCLK1; 

UUT1 : diviseur
generic map( w => 868 )
Port map (
    CLK100MHZ => CLK,
    reset => reset_top,
    sortieLed => diviseurCLK1
    );

UUT2 : StateMachine
Port map ( 
    uart => uart_in,
    CLK100MHZ => CLK,
    clkDiviseur => diviseurCLK2,
    reset => reset_top,
    error => erreur_top,
    --diviseurReset => resetDiviseur,
    donnee => donnee_recu
    );
UUT3 : aff7seg
port map (
        clk100mhz => CLK,
        heures_1    => sg, 
        heures_2    => sp,
        minutes_1   => se, 
        minutes_2   => sf,
        secondes_1  => sc, 
        secondes_2  => sd,
        centiemes_1 => sa, 
        centiemes_2 => sb,
        an => an,
        ca => ca, 
        cb => cb, 
        cc => cc, 
        cd => cd,
        ce => ce, 
        cf => cf, 
        cg => cg, 
        dp => dp
    );
    
sa <= sa & donnee_recu(0);
sb <= sb & donnee_recu(1);
sc <= sc & donnee_recu(2);
sd <= sd & donnee_recu(3);
se <= se& donnee_recu(4);
sf <= sf & donnee_recu(5);
sg <= sg & donnee_recu(6);
sp <= sp & donnee_recu(7);

UART_RXD_OUT <= uart_in;

end Behavioral;
