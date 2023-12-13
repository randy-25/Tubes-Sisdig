LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY mux IS
    PORT (
        input_0, input_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        reset, clock, mode : IN STD_LOGIC;
        output_f : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF mux IS
BEGIN
    PROCESS (reset, clock, mode)
    BEGIN
        IF reset = '1' THEN
            output_f <= (OTHERS => 'Z');
        ELSIF clock'event AND clock = '1' THEN
            IF mode = '0' THEN
                output_f <= input_0;
            ELSIF mode = '1' THEN
                output_f <= input_1;
            END IF;
        END IF;
    END PROCESS;
END behavioral;