LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY subtractor IS
    PORT (
        reset, clock, compared : IN STD_LOGIC;
        x_i, y_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        d_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF subtractor IS
    COMPONENT CLOCKDIV IS
        PORT (
            CLK : IN STD_LOGIC;
            divider : IN INTEGER;
            DIVOUT : BUFFER std_logic
        );
    END COMPONENT;

    SIGNAL clockdivider : std_logic;

BEGIN
    clockX : CLOCKDIV PORT MAP(clock, 3, clockdivider);
    PROCESS (clockdivider, reset, compared)
        CONSTANT zero : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF reset = '1' THEN
            d_out <= (OTHERS => '0');
        ELSIF clockdivider'event AND clockdivider = '1' THEN
            IF x_i /= zero AND y_i /= zero THEN
                IF compared = '1' THEN
                    d_out <= y_i - x_i;
                ELSIF compared = '0' THEN
                    d_out <= x_i - y_i;
                END IF;
            ELSE
                d_out <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;
END behavioral;