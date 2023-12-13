library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.ALL;

entity ascii_to_bcd is
	port( 
		ascii : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		bcd : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
end ascii_to_bcd;

architecture y of ascii_to_bcd is
begin
	process (ascii) begin
	if ascii = "00110000" then
		bcd <= "0000";
	elsif ascii = "00110001" then
		bcd <= "0001";
	elsif ascii = "00110010" then
		bcd <= "0010";
	elsif ascii = "00110011" then
		bcd <= "0011";
	elsif ascii = "00110100" then
		bcd <= "0100";
	elsif ascii = "00110101" then
		bcd <= "0101";
	elsif ascii = "00110110" then
		bcd <= "0110";
	elsif ascii = "00110111" then
		bcd <= "0111";
	elsif ascii = "00111000" then
		bcd <= "1000";
	elsif ascii = "00111001" then
		bcd <= "1001";
	else
		bcd <= "1111";
	end if;
	end process;
end architecture;