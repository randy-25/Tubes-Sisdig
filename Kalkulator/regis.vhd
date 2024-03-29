LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY regis IS
    PORT (
        reset, clock, enable : IN STD_LOGIC;
        x_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        x_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF regis IS
   
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
    PROCESS (clockdivider, reset, enable)
    constant zero : std_logic_vector(31 downto 0) := (others => '0');
    BEGIN
        IF reset = '1' THEN
            x_out <= (OTHERS => '0');
        ELSIF clockdivider'event and clockdivider = '1' THEN
            IF enable = '1' and x_in /= zero THEN
                x_out <= x_in;
            else 
                x_out <= (others => '0');
            END IF;
        END IF;
    END PROCESS;
END behavioral;