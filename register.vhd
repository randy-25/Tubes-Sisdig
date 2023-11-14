LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY regis IS
    PORT (
        rst, clk, load : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END regis;
ARCHITECTURE regis_arc OF regis IS
BEGIN
    PROCESS (rst, clk, load, input)
    BEGIN
        IF (rst = '1') THEN
            output <= "0000";
        ELSIF (clk'event AND clk = '1') THEN
            IF (load = '1') THEN
                output <= input;
            END IF;
        END IF;
    END PROCESS;
END regis_arc;