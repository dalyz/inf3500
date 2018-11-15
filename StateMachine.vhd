library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity StateMachine is
    Port ( 
    uart : in std_logic;
    CLK100MHZ, reset : in std_logic;
    error : out std_logic;
    donnee : out std_logic_vector (7 downto 0)
    );
end StateMachine;

architecture Behavioral2 of StateMachine is

component diviseur is
 Port (
    CLK100MHZ, reset : in std_logic;
   sortieLed : out std_logic
    );
end component diviseur;


type type_etat is (S0, S1, S2);
signal state : type_etat := S0;
signal erreur : std_logic := '0';
signal signalbaud : std_logic;

signal diviseurCLK : std_logic;
signal notReset : std_logic;

-- Pour le testBench
signal donnee : std_logic_vector (7 downto 0) := "00000000";
signal donneeCompteur : integer := 0;

begin

--UUT : diviseur
UUT : entity work.diviseur(Behavioral)
Port map(
CLK100MHZ => diviseurCLK,
reset => notReset,
sortieLed => signalbaud
);

process(diviseurCLK, reset, uart, signalbaud) is
--variable donnee : std_logic_vector (7 downto 0) := "00000000";
--variable donneeCompteur : integer := 0;
variable donneeAdd : integer := 0;
begin
    if (rising_edge(diviseurCLK)) then
        if(reset = '1') then
            state <= S0;
            erreur <= '0';
            error <= erreur;
        else
            case state is
            -- State 0 : on attend le startbit qui est 0
            -- sert à synchroniser le recepteur uart
            when S0 =>
                if(uart = '0') then
                    state <= S1;
                else 
                    state <= S0;
                end if;
                
            -- State 1 : on va lire les prochains 8 bits à vitesse 57 600 bits/seconde 
            -- On vérifie la parité et on envoie erreur si besoin
            when S1 =>
            while (donneeCompteur < 8) loop
                if (signalbaud = '1') then
                    donnee(7) <= donnee(6);
                    donnee(6) <= donnee(5);
                    donnee(5) <= donnee(4);
                    donnee(4) <= donnee(3);
                    donnee(3) <= donnee(2);
                    donnee(2) <= donnee(1);
                    donnee(1) <= donnee(0);
                    donnee(0) <= uart;
                end if;   
                donneeCompteur <= donneeCompteur + 1;    
             end loop;
            donneeCompteur <= 0;
            for k in 0 to 7 loop
                if (donnee(k) = '1') then
                    donneeAdd := donneeAdd + 1;
                end if;
            end loop;
            donneeAdd := donneeAdd mod 2;
            
            
            if(donneeAdd = 0) then
                erreur <= '1';
                error <= erreur;
                state <= S2;
            else
                erreur<='0';
                error <= erreur;
                state <= S2;
                donneeAdd := 0;
            end if;
            
            -- State 2 : On attend le stopbit
            when S2 =>
                if(uart = '1') then
                    state <= S0;
                else
                    state <= S2;
                end if;
                
            -- Pour les autres états qui existe pas
            when OTHERS => 
                state <= S0;
            end case;
        end if;
    end if;
end process;

end Behavioral2;
