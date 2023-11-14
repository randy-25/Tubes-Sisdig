LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY subtractor IS
    PORT (
        rst : IN STD_LOGIC;
        cmd : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        x, y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        xout, yout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END subtractor;
ARCHITECTURE subtractor_arc OF subtractor IS
BEGIN
    PROCESS (rst, cmd, x, y)
    BEGIN
        IF (rst = '1' OR cmd = "00") THEN -- not active. 
            xout <= "0000";
            yout <= "0000";
        ELSIF (cmd = "10") THEN -- x is greater 
            xout <= (x - y);
            yout <= y;
        ELSIF (cmd = "01") THEN -- y is greater 
            xout <= x;
            yout <= (y - x);
        ELSE
            xout <= x; -- x and y are equal 
            yout <= y;
        END IF;
    END PROCESS;
END subtractor_arc;