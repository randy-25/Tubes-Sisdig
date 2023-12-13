library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.ALL;

entity bcd_to_ascii is
	port( 
		bcd : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		ascii : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
end bcd_to_ascii;

architecture y of bcd_to_ascii is
begin
	process (bcd) begin
	if bcd = "0000" then
		ascii <= "00110000";
	elsif bcd = "0001" then
		ascii <= "00110001";
	elsif bcd = "0010" then
		ascii <= "00110010";
	elsif bcd = "0011" then
		ascii <= "00110011";
	elsif bcd = "0100" then
		ascii <= "00110100";
	elsif bcd = "0101" then
		ascii <= "00110101";
	elsif bcd = "0110" then
		ascii <= "00110110";
	elsif bcd = "0111" then
		ascii <= "00110111";
	elsif bcd = "1000" then
		ascii <= "00111000";
	elsif bcd = "1001" then
		ascii <= "00111001";
	else
		ascii <= "00000000";
	end if;
	end process;
end architecture;