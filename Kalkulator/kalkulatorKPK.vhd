LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY kalkulatorKPK IS
    PORT (
        clk, rst, go_i : IN STD_LOGIC;
        a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        d_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        done : out std_logic
    );
END ENTITY;

ARCHITECTURE behavioral OF kalkulatorKPK IS
    COMPONENT kpk IS
        PORT (
            rst, clk, go_i : IN STD_LOGIC;
            x_i, y_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            d_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            state : OUT INTEGER
        );
    END COMPONENT;
    SIGNAL rst_in : STD_LOGIC;
    SIGNAL a_input, b_input, c_input, d_input : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL lcm1, lcm2, lcm3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_1, in_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL state1, state2, state3 : INTEGER;
BEGIN
    PROCESS (a_i, b_i, c_i, d_i, a_input, b_input, c_input, d_input)
        VARIABLE count : INTEGER := 0;
    BEGIN
        a_input <= "000000000000000000000000" & a_i;
        b_input <= "000000000000000000000000" & b_i;
        c_input <= "000000000000000000000000" & c_i;
        d_input <= "000000000000000000000000" & d_i;
    END PROCESS;

    proc1 : kpk PORT MAP(rst, clk, go_i, a_input, b_input, lcm1, state1);
    proc2 : kpk PORT MAP(rst, clk, go_i, c_input, d_input, lcm2, state2);
    PROCESS (rst, clk, lcm1, lcm2)

    BEGIN
        IF rst = '1' THEN
            rst_in <= '1';
            in_1 <= (OTHERS => '0');
            in_2 <= (OTHERS => '0');
        END IF;
        if state1 = 5 and state2 = 5 then
            rst_in <= '0';
            in_1 <= lcm1;
            in_2 <= lcm2;
        else
			in_1 <= (OTHERS => '0');
            in_2 <= (OTHERS => '0');
            rst_in <= '1';
        end if;
    END PROCESS;
    proc3 : kpk PORT MAP(rst_in, clk, go_i, in_1, in_2, lcm3, state3);
    d_o <= lcm3;

    process(state3)
    begin
        if state3 = 5 then
            done <= '1';
        else 
            done <= '0';
        end if;
    end process;
END behavioral;