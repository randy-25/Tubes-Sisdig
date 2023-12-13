LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY binarytobcd8bit IS
	PORT (
		bin : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		bcd1 : out std_logic_vector(3 downto 0);
		bcd2 : out std_logic_vector(3 downto 0);
		bcd3 : out std_logic_vector(3 downto 0)
	);
END ENTITY;

ARCHITECTURE rtl OF binarytobcd8bit IS
	signal bcd_o : STD_LOGIC_VECTOR (11 DOWNTO 0);
BEGIN
	PROCESS (bin)
		VARIABLE binx : STD_LOGIC_VECTOR (7 DOWNTO 0);
		VARIABLE bcd : STD_LOGIC_VECTOR (11 DOWNTO 0);
	BEGIN
		bcd := (OTHERS => '0');
		binx := bin(7 DOWNTO 0);

		FOR i IN binx'RANGE LOOP
			IF bcd(3 DOWNTO 0) > "0100" THEN
				bcd(3 DOWNTO 0) := STD_LOGIC_VECTOR(unsigned(bcd(3 DOWNTO 0)) + "0011");
			END IF;
			IF bcd(7 DOWNTO 4) > "0100" THEN
				bcd(7 DOWNTO 4) := STD_LOGIC_VECTOR(unsigned(bcd(7 DOWNTO 4)) + "0011");
			END IF;
			bcd := bcd(10 DOWNTO 0) & binx(7);
			binx := binx(6 DOWNTO 0) & '0';
		END LOOP;
		bcd_o <= bcd;
	END PROCESS;

	bcd1 <= bcd_o(11 downto 8);
	bcd2 <= bcd_o(7 downto 4);
	bcd3 <= bcd_o(3 downto 0);
END ARCHITECTURE;