LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY binarytobcd32bit IS
	PORT (
		bin : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		bcd1 : out std_logic_vector(3 downto 0);
		bcd2 : out std_logic_vector(3 downto 0);
		bcd3 : out std_logic_vector(3 downto 0);
		bcd4 : out std_logic_vector(3 downto 0);
		bcd5 : out std_logic_vector(3 downto 0);
		bcd6 : out std_logic_vector(3 downto 0);
		bcd7 : out std_logic_vector(3 downto 0);
		bcd8 : out std_logic_vector(3 downto 0);
		bcd9 : out std_logic_vector(3 downto 0);
		bcd10 : out std_logic_vector(3 downto 0)
	);
END ENTITY;

ARCHITECTURE rtl OF binarytobcd32bit IS
	signal bcd_o : STD_LOGIC_VECTOR (39 DOWNTO 0);
BEGIN
	PROCESS (bin)
		VARIABLE binx : STD_LOGIC_VECTOR (31 DOWNTO 0);
		VARIABLE bcd : STD_LOGIC_VECTOR (39 DOWNTO 0);
	BEGIN
		bcd := (OTHERS => '0');
		binx := bin(31 DOWNTO 0);

		FOR i IN binx'RANGE LOOP
			IF bcd(3 DOWNTO 0) > "0100" THEN
				bcd(3 DOWNTO 0) := STD_LOGIC_VECTOR(unsigned(bcd(3 DOWNTO 0)) + "0011");
			END IF;
			IF bcd(7 DOWNTO 4) > "0100" THEN
				bcd(7 DOWNTO 4) := STD_LOGIC_VECTOR(unsigned(bcd(7 DOWNTO 4)) + "0011");
			END IF;
            IF bcd(11 DOWNTO 8) > "0100" THEN
				bcd(11 DOWNTO 8) := STD_LOGIC_VECTOR(unsigned(bcd(11 DOWNTO 8)) + "0011");
			END IF;
            IF bcd(15 DOWNTO 12) > "0100" THEN
				bcd(15 DOWNTO 12) := STD_LOGIC_VECTOR(unsigned(bcd(15 DOWNTO 12)) + "0011");
			END IF;
            IF bcd(19 DOWNTO 16) > "0100" THEN
				bcd(19 DOWNTO 16) := STD_LOGIC_VECTOR(unsigned(bcd(19 DOWNTO 16)) + "0011");
			END IF;
            IF bcd(23 DOWNTO 20) > "0100" THEN
				bcd(23 DOWNTO 20) := STD_LOGIC_VECTOR(unsigned(bcd(23 DOWNTO 20)) + "0011");
			END IF;
            IF bcd(27 DOWNTO 24) > "0100" THEN
				bcd(27 DOWNTO 24) := STD_LOGIC_VECTOR(unsigned(bcd(27 DOWNTO 24)) + "0011");
			END IF;
            IF bcd(31 DOWNTO 28) > "0100" THEN
				bcd(31 DOWNTO 28) := STD_LOGIC_VECTOR(unsigned(bcd(31 DOWNTO 28)) + "0011");
			END IF;
            IF bcd(35 DOWNTO 32) > "0100" THEN
				bcd(35 DOWNTO 32) := STD_LOGIC_VECTOR(unsigned(bcd(35 DOWNTO 32)) + "0011");
			END IF;
            IF bcd(39 DOWNTO 36) > "0100" THEN
				bcd(39 DOWNTO 36) := STD_LOGIC_VECTOR(unsigned(bcd(39 DOWNTO 36)) + "0011");
			END IF;
			bcd := bcd(38 DOWNTO 0) & binx(31);
			binx := binx(30 DOWNTO 0) & '0';
		END LOOP;
		bcd_o <= bcd;
	END PROCESS;
	bcd1 <= bcd_o(39 downto 36);
	bcd2 <= bcd_o(35 downto 32);
	bcd3 <= bcd_o(31 downto 28);
	bcd4 <= bcd_o(27 downto 24);
	bcd5 <= bcd_o(23 downto 20);
	bcd6 <= bcd_o(19 downto 16);
	bcd7 <= bcd_o(15 downto 12);
	bcd8 <= bcd_o(11 downto 8);
	bcd9 <= bcd_o(7 downto 4);
	bcd10 <= bcd_o(3 downto 0);
END ARCHITECTURE;