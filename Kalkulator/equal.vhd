LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY equal IS
    PORT (
        reset, clock : IN STD_LOGIC;
        x_in, y_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        eq_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF equal IS
BEGIN
    PROCESS (clock, reset)
        CONSTANT zero : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        CONSTANT highZ : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => 'Z');
    BEGIN
        IF (reset = '1') THEN
            eq_out <= 'Z';
        ELSIF (clock'event AND clock = '1') THEN
            IF ((x_in = y_in) AND (x_in /= zero)) THEN
                eq_out <= '1';
            ELSE
                eq_out <= '0';
            END IF;
        END IF;
    END PROCESS;
END behavioral;