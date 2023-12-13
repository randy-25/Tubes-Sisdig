LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY comparator IS
    PORT (
        reset, clock : IN STD_LOGIC;
        x_in, y_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        d_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF comparator IS
BEGIN
    PROCESS (clock, reset)
    BEGIN
        IF (reset = '1') THEN
            d_out <= 'Z';
        ELSIF (clock'event AND clock = '1') THEN
            IF (x_in < y_in) THEN
                d_out <= '1';
            ELSIF (x_in > y_in) THEN
                d_out <= '0';
            END IF;
        END IF;
    END PROCESS;
END behavioral;