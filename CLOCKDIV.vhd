LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CLOCKDIV IS PORT (
	CLK : IN STD_LOGIC;
	divider : in integer;
	DIVOUT : buffer std_logic);
END CLOCKDIV;

ARCHITECTURE behavioural OF CLOCKDIV IS
signal div_cek : std_logic;
BEGIN
	PROCESS (CLK, div_cek, divider)
		VARIABLE count : INTEGER := 0;
		variable div : INTEGER;
		
	BEGIN
		div := divider;
		DIVOUT <= div_cek;
		IF CLK'event AND CLK = '1' THEN

			IF (count < div) THEN
				count := count + 1;
				IF (div_cek = '0') THEN
					div_cek <= '0';
				ELSIF (div_cek = '1') THEN
					div_cek <= '1';
				END IF;
			ELSE
				IF (div_cek = '0') THEN
					div_cek <= '1';
				ELSIF (div_cek = '1') THEN
					div_cek <= '0';
				END IF;
				count := 0;
			END IF;

		END IF;
	END PROCESS;
END behavioural;