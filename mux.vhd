LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY mux IS
    PORT (
        rst, sLine : IN STD_LOGIC;
        load, result : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END mux;
ARCHITECTURE mux_arc OF mux IS
BEGIN
    PROCESS (rst, sLine, load, result)
    BEGIN
        IF (rst = '1') THEN
            output <= "0000"; -- do nothing 
        ELSIF sLine = '0' THEN
            output <= load; -- load inputs 
        ELSE
            output <= result; -- load results 
        END IF;
    END PROCESS;
END mux_arc;