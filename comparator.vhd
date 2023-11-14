LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY comparator IS
    PORT (
        rst : IN STD_LOGIC;
        x, y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END comparator;
ARCHITECTURE comparator_arc OF comparator IS
BEGIN
    PROCESS (x, y, rst)
    BEGIN
        IF (rst = '1') THEN
            output <= "00"; -- do nothing 
        ELSIF (x > y) THEN
            output <= "10"; -- if x greater 
        ELSIF (x < y) THEN
            output <= "01"; -- if y greater 
        ELSE
            output <= "11"; -- if equivalance. 
        END IF;
    END PROCESS;
END comparator_arc;