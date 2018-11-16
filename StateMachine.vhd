library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity StateMachine is
    Port ( 
    uart : in std_logic;
    CLK100MHZ, clkDiviseur, reset : in std_logic;
    error : out std_logic;
    --diviseurReset : out std_logic;
    donnee : out std_logic_vector (7 downto 0)
    );
end StateMachine;

architecture Behavioral2 of StateMachine is

type type_etat_machine is (STARTBIT, LECTURE, STOPBIT);
type type_etat_lecture is (ATTENTE, LECTUREBITS, PARITE);
signal stateLecture : type_etat_lecture := ATTENTE;
signal stateMachine : type_etat_machine := STARTBIT;
signal erreur : std_logic := '0';
signal modeLecture  : std_logic := '0';
signal modeActif : std_logic := '1';

signal donnee_signal : std_logic_vector (8 downto 0) := "000000000";


begin
process(CLK100MHZ, reset) is
begin
    if(reset = '1') then
        modeLecture <= '0';
        modeActif <= '1';
        stateMachine <= STARTBIT;
        erreur <= '0';
        error <= erreur;
    elsif (rising_edge(CLK100MHZ)) then
        case stateMachine is
            -- State 0 : on attend le startbit qui est 0
            -- sert à synchroniser le recepteur uart
        when STARTBIT =>
                if(uart = '0') then
                    stateMachine <= LECTURE;
                else 
                    stateMachine <= STARTBIT;
                end if;
                
            -- State 1 : on va activer l'autre process et attendre que celui-ci finisse avant de continuer
        when LECTURE =>
            modeLecture <= '1';
            modeActif <= '0';
            if (modeActif = '0') then
                stateMachine <= LECTURE;
            elsif (modeLecture <= '0') then
                stateMachine <= STOPBIT;
            end if;
        
            -- State 2 : On attend le stopbit
        when STOPBIT =>
                if(uart = '1') then
                    stateMachine <= STARTBIT;
                else
                    stateMachine <= STOPBIT;
                end if;
                
            -- Pour les autres états qui existe pas
            when OTHERS => 
                stateMachine <= STARTBIT;
            end case;
        end if;
end process;

process(clkDiviseur, reset)    
variable compteur : integer := 0;
variable bitLus : integer := 0 ;
begin
if (reset = '1') then
    stateLecture <= ATTENTE;
    compteur := 0;
    modeLecture <= '0';
else
case stateLecture is 
when ATTENTE =>
    if (modeLecture = '0') then
        stateLecture <= ATTENTE;
    else 
        stateLecture <= LECTUREBITS;
    end if;
    
when LECTUREBITS =>
    if (rising_edge(clkDiviseur)) then
        if (uart = '1') then
            compteur := compteur + 1;
        end if;
        donnee_signal <= uart & donnee_signal(8 downto 1);
        bitLus := bitLus + 1;
        if ( bitLus < 9) then
            stateLecture <= LECTUREBITS;
        elsif (bitLus = 9) then
            stateLecture <= PARITE;
        end if;
    end if; 
       
when PARITE =>
    if ( compteur mod 2 = 1) then
        compteur := 0;
        erreur <= '0';
        modeLecture <= '0';
    elsif (compteur mod 2 = 0) then
        compteur := 0;
        erreur <= '1';
        modeLecture <= '0';
    end if;
    stateLecture <= ATTENTE;
    
when others =>
    stateLecture <= ATTENTE;
end case;
end if;
end process;
error <= erreur;
donnee <= donnee_signal (8 downto 1);
end Behavioral2;
