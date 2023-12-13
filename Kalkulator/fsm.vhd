LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY fsm IS
    PORT (
        rst, clk, go, compared, equal_x : IN STD_LOGIC;
        go_o, enable, modeX, modeY : OUT STD_LOGIC;
        cstate : OUT INTEGER
    );
END ENTITY;

ARCHITECTURE behavioral OF fsm IS

    COMPONENT CLOCKDIV IS
        PORT (
            CLK : IN STD_LOGIC;
            divider : IN INTEGER;
            DIVOUT : BUFFER std_logic
        );
    END COMPONENT;

    TYPE states IS (init, load, compare, x_greater, x_less_than, x_equal);
    SIGNAL nextState : states;
    SIGNAL currentState : states := init;
    SIGNAL clockdivider : std_logic;
BEGIN
    clockX : CLOCKDIV PORT MAP(clk, 7, clockdivider);
    PROCESS (rst, clockdivider)
    BEGIN
        IF (rst = '1') THEN
            currentState <= init;
        ELSIF (clockdivider'event AND clockdivider = '1') THEN
            currentState <= nextState;
        END IF;
    END PROCESS;
    PROCESS (rst, clockdivider, currentState)
    BEGIN
        CASE currentState IS
            WHEN init =>
                cstate <= 0;
                modeX <= '0';
                modeY <= '0';
                enable <= '1';
                go_o <= '0';
                IF go = '0' THEN
                    nextState <= init;
                ELSE
                    nextState <= load;
                END IF;

            WHEN load =>
                cstate <= 1;
                go_o <= '0';
                enable <= '1';
                modeX <= '0';
                modeY <= '0';
                nextState <= compare;
            WHEN compare =>
                cstate <= 2;
                go_o <= '1';
                enable <= '1';
                modeX <= '0';
                modeY <= '0';
                IF equal_x = '1' THEN
                    nextState <= x_equal;
                ELSIF compared = '1' THEN
                    nextState <= x_less_than;
                ELSIF compared = '0' THEN
                    nextState <= x_greater;
                END IF;
            WHEN x_greater =>
                cstate <= 3;
                enable <= '1';
                modeX <= '1';
                modeY <= '0';
                go_o <= '1';
                nextState <= compare;
            WHEN x_less_than =>
                cstate <= 4;
                enable <= '1';
                modeX <= '0';
                modeY <= '1';
                go_o <= '1';
                nextState <= compare;
            WHEN x_equal =>
                cstate <= 5;
                go_o <= '1';
                modeX <= '0';
                modeY <= '0';
                enable <= '1';
                nextState <= x_equal;
        END CASE;
    END PROCESS;
END behavioral;