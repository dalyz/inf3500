library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity diviseur is
    Generic (
    -- Pour avoir un clock avec rising_edge à chaque seconde : k = 50000000
    -- cela vient de : 100MHz / (demi-periode)^(-1) ici on voulait une periode de 1 s.
    -- Maintenant on veut lire 57 600 fois plus vite donc : 50000000/57600 
    w : integer := 868
    );
    Port (
 
    CLK100MHZ, reset : in std_logic;
    sortieLed : out std_logic
     );
end diviseur;

architecture Behavioral of diviseur is

signal k : integer:=1;
signal led : std_logic:= '0';
begin

process(CLK100MHZ, reset) is 
begin 
        if(reset ='1') then
            k <= 1;
            led <= '0';
        elsif(rising_edge(CLK100MHZ)) then
            k <= k + 1;
            if(k = w) then
                led <= not led;
                k <= 1;
            end if;
        end if;    
        sortieLed <= led;
end process;
end Behavioral;
