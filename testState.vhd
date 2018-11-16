library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testState is
end testState;

architecture Behavioral4 of testState is

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
process(signalCLK) is
begin

if (rising_edge(signalCLK)) then
        signalUart <= '0'; -- start bit
        signalUart <= '0'; -- bit 0
        signalUart <= '0'; -- bit 1
        signalUart <= '0'; -- bit 2
        signalUart <= '1'; -- bit 3
        signalUart <= '0'; -- bit 4
        signalUart <= '1'; -- bit 5
        signalUart <= '1'; -- bit 6
        signalUart <= '0'; -- bit 7
        signalUart <= '0'; -- parity
        signalUart <= '1'; -- stop bit
        
end if;
end process;

end Behavioral4;