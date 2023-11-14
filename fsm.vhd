LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY fsm IS
    PORT (
        rst, clk, proceed : IN STD_LOGIC;
        comparison : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        enable, xsel, ysel, xld, yld : OUT STD_LOGIC
    );
END fsm;
ARCHITECTURE fsm_arc OF fsm IS
    TYPE states IS (init, s0, s1, s2, s3, s4, s5);
    SIGNAL nState, cState : states;
BEGIN
    PROCESS (rst, clk)
    BEGIN
        IF (rst = '1') THEN
            cState <= init;
        ELSIF (clk'event AND clk = '1') THEN
            cState <= nState;
        END IF;
    END PROCESS;
    PROCESS (proceed, comparison, cState)
    BEGIN
        CASE cState IS
            WHEN init => IF (proceed = '0') THEN
                nState <= init;
            ELSE
                nState <= s0;
        END IF;
        WHEN s0 => 
            enable <= '0';
            xsel <= '0';
            ysel <= '0';
            xld <= '0';
            yld <= '0';
            nState <= s1;
        WHEN s1 =>
            enable <= '0';
            xsel <= '0';
            ysel <= '0';
            xld <= '1';
            yld <= '1';
            nState <= s2;
        WHEN s2 => 
            xld <= '0';
            yld <= '0';
            IF (comparison = "10") THEN
                nState <= s3;
            ELSIF (comparison = "01") THEN
                nState <= s4;
            ELSIF (comparison = "11") THEN
                nState <= s5;
            END IF;
        WHEN s3 => 
            enable <= '0';
            xsel <= '1';
            ysel <= '0';
            xld <= '1';
            yld <= '0';
            nState <= s2;
        WHEN s4 => 
            enable <= '1';
            xsel <= '1';
            ysel <= '1';
            xld <= '1';
            yld <= '1';
            nState <= s0;
        WHEN s5 => 
            enable <= '0';
            xsel <= '0';
            ysel <= '1';
            xld <= '0';
            yld <= '1';
            nState <= s2;
        WHEN OTHERS => nState <= s0;
    END CASE;
END PROCESS;
END fsm_arc;