library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aff7seg is 	  
port (
	clk100mhz : in std_logic;
	heures_1,heures_2 : in  std_logic_vector(7 downto 0);
	minutes_1,minutes_2 : in  std_logic_vector(7 downto 0);
	secondes_1,secondes_2: in  std_logic_vector(7 downto 0);
	centiemes_1,centiemes_2: in  std_logic_vector(7 downto 0);
	an : out std_logic_vector(7 downto 0);
	ca, cb, cc, cd, ce, cf, cg, dp : out std_logic
);
end aff7seg;

architecture arch1 of aff7seg is

signal clk : std_logic;
--constant message : string := "abcdefgh";

signal afficheur : integer range 0 to 7 := 0;
signal a7s_anodes, a7s_cathodes : std_logic_vector(7 downto 0);
														
--function to7seg(c: character) return std_logic_vector is
--variable v : std_logic_vector(7 downto 0);
--begin
--	case c is
--		when 'a' | 'A' => v := "00010001";
--		when 'b' | 'B' => v := "11000001";	  
--		when 'c' | 'C' => v := "01100011";	  
--		when 'd' | 'D' => v := "10000101";	  
--		when 'e' | 'E' => v := "01100001";	  
--		when 'f' | 'F' => v := "01110001";	  
--		when 'g' | 'G' => v := "00001001";	  
--		when 'h' | 'H' => v := "10010001";	  
--		
--		when '0' => v :="00000011";
--		when '1' => v :="10011111";
--		when '2' => v :="00100101";
--		when '3' => v :="00001101";
--		when '4' => v :="10011001";
--		when '5' => v :="01001001";
--		when '6' => v :="01000001";
--		when '7' => v :="00011111";
--		when '8' => v :="00000001";
--		when '9' => v :="00001001";
--		when '.' => v :="11111110";
--		
--		when others => v :="11111111";
--		
--	end case;
--	
--	return v;
--
--end;

function to7seg(i: std_logic_vector) return std_logic_vector is
variable v : std_logic_vector(7 downto 0);
begin
	case to_integer(unsigned(i)) is
		
		when 0 => v :="00000011";
		when 1 => v :="10011111";
		when 2 => v :="00100101";
		when 3 => v :="00001101";
		when 4 => v :="10011001";
		when 5 => v :="01001001";
		when 6 => v :="01000001";
		when 7 => v :="00011111";
		when 8 => v :="00000001";
		when 9 => v :="00001001";
		
		when others => v :="11111101";
		
	end case;
	
	return v;

end;

type Table is array(0 to 7) of std_logic_vector(7 downto 0);
signal message : Table;
signal tiret : unsigned(7 downto 0) := "11111111";
begin		

	message(0) <= centiemes_1;
	message(1) <= centiemes_2;
	message(2) <= secondes_1; -- point
	message(3) <= secondes_2;
	message(4) <= minutes_1; -- point
	message(5) <= minutes_2;
	message(6) <= heures_1; -- point
	message(7) <= heures_2;
	
	-- Diviseur d'horloge
	-- L'horloge de 100 MHz est ramen�e � environ 1 kHz (100 MHz divis� par 2^17).
	process(clk100MHz)
	variable compte : unsigned(16 downto 0);
	begin
		if rising_edge(clk100MHz) then
			compte := compte + 1;
		end if;
		clk <= compte(compte'left);
	end process;
	
	process (clk, afficheur, message)
	begin
		if rising_edge(clk) then
			if afficheur = 7 then
				afficheur <= 0;
			else
				afficheur <= afficheur + 1;
			end if;
		end if;
		a7s_anodes <= (others => '1');
		a7s_anodes(afficheur) <= '0';
		a7s_cathodes <= to7seg(message(afficheur));
		
	end process;

	an <= a7s_anodes;
	(ca, cb, cc, cd, ce, cf, cg, dp) <= a7s_cathodes(a7s_cathodes'high downto 1) & '0'	-- Les points
											when afficheur = 2 or afficheur = 4 or afficheur = 6 else
										a7s_cathodes;

end architecture arch1;
