LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY bcdtobinary8bit IS
	PORT (
		bcd_i : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		bin_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)

	);
END ENTITY;

ARCHITECTURE rtl OF bcdtobinary8bit IS
BEGIN

	PROCESS (bcd_i)
		VARIABLE bin : STD_LOGIC_VECTOR (7 DOWNTO 0);
		VARIABLE bcd : STD_LOGIC_VECTOR (11 DOWNTO 0);
	BEGIN
		bcd := bcd_i;
		bin := (OTHERS => '0');

		FOR i IN 0 TO 7 LOOP
			IF i >= 1 AND bcd(3 DOWNTO 0) >= "1000" THEN
				bcd(3 DOWNTO 0) := STD_LOGIC_VECTOR(unsigned(bcd(3 DOWNTO 0)) - "0011");
			END IF;
			IF i >= 4 AND bcd(7 DOWNTO 4) >= "1000" THEN
				bcd(7 DOWNTO 4) := STD_LOGIC_VECTOR(unsigned(bcd(7 DOWNTO 4)) - "0011");
			END IF;
			bin := bcd(0) & bin(7 DOWNTO 1);
			bcd := '0' & bcd(11 DOWNTO 1);
		END LOOP;
		bin_o <= bin;
	END PROCESS;
END ARCHITECTURE;