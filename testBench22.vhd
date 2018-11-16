library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testBench22 is
end testBench22;

architecture Behavioral of testBench22 is

constant UART_PERIOD : time := (real(1)/real(57600)) * 1 sec;

component Top is
Port ( 
    CLK : in std_logic;
    reset_top : in std_logic;
    uart_in : in std_logic;
    erreur_top : out std_logic
    );
end component Top;

signal signalCLK : std_logic := '0';
signal signalReset : std_logic;
signal signalUart : std_logic;
signal signalErreur : std_logic := '0';
constant periode : time := 10 ns;

begin 
signalCLK <= not signalCLK after periode/2;
signalReset <= '1' after 0 ns, '0' after 10 ns;

UUT : Top
Port map(
    CLK => signalCLK,
    reset_top => signalReset,
    uart_in => signalUart,
    erreur_top => signalErreur
);

process
constant vecteurTest : std_logic_vector := "11111100001011001";
variable compte : natural range 0 to vecteurTest'length := 0;
begin
    wait for  8680ns;

        signalUart <= vecteurTest(compte);
        compte := compte + 1;
   
end process;
end Behavioral;