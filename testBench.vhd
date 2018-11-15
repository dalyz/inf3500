library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testBench is
end testBench;

architecture Behavioral3 of testBench is

component StateMachine is
Port(
    uart : in std_logic;
    CLK100MHZ, reset : in std_logic;
    error : out std_logic
);
end component StateMachine;

component diviseur is
 Port (
    CLK100MHZ, reset : in std_logic;
   sortieLed : out std_logic
    );
end component diviseur;

signal uart: std_logic:='0';
signal signalCLK100MHZ: std_logic:='0';
signal reset: std_logic;
signal baud: std_logic;
signal erreur: std_logic;
constant periode : time := 10 ns;

begin

signalCLK100MHZ <= not signalCLK100MHZ after periode/2;
reset <= '1' after 0 ns, '0' after 10 ns;

UUT1: entity work.StateMachine(Behavioral2)
Port map(
uart => uart,
CLK100MHZ => signalCLK100MHZ,
reset => reset,
error => erreur
);

UUT2 : entity work.diviseur(Behavioral)
Port map(
CLK100MHZ => signalCLK100MHZ,
reset => reset,
sortieLed => baud
);


process(signalCLK100MHZ)
constant vecteurTest : std_logic_vector := "111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111111000000010011111111111111111111111101111111";
variable compte : natural range 0 to vecteurTest'length := 0;
begin

    if (rising_edge(signalCLK100MHZ)) then
        --uart <= vecteurTest(compte);
        compte := compte + 1;
    end if;
end process;
end Behavioral3;