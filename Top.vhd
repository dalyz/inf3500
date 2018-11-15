library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Top is
    Port ( 
    CLK : in std_logic;
    reset_top : in std_logic;
    uart_in : in std_logic;
    erreur_top : out std_logic
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

--signal resetDiviseur : std_logic;
signal diviseurCLK : std_logic;
signal donnee_recu : std_logic_vector (7 downto 0);

begin

UUT1 : diviseur
generic map( w => 868 )
Port map (
    CLK100MHZ => CLK,
    reset => reset_top,
    sortieLed => diviseurCLK
    );

UUT2 : StateMachine
Port map ( 
    uart => uart_in,
    CLK100MHZ => CLK,
    clkDiviseur => diviseurCLK,
    reset => reset_top,
    error => erreur_top,
    --diviseurReset => resetDiviseur,
    donnee => donnee_recu
    );

end Behavioral;
