LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY kalkulatorFPB IS
    PORT (
        clk, rst, go_i : IN STD_LOGIC;
        a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        d_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        done : out std_logic
    );
END ENTITY;

ARCHITECTURE behavioral OF kalkulatorFPB IS

    COMPONENT fpb IS
        PORT (
            rst, clk, go_i : IN STD_LOGIC;
            x_input, y_input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            d_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            state : OUT INTEGER
        );
    END COMPONENT;

    SIGNAL gcd1, gcd2, gcd3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL in_1, in_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL rst_in : STD_LOGIC := '1';
    SIGNAL state1, state2, state3 : INTEGER;

BEGIN
    proc1 : fpb PORT MAP(rst, clk, go_i, a_i, b_i, gcd1, state1);
    proc2 : fpb PORT MAP(rst, clk, go_i, c_i, d_i, gcd2, state2);
    PROCESS (rst, clk, gcd1, gcd2)
    BEGIN
        IF rst = '1' THEN
            rst_in <= '1';
            in_1 <= (others => '0');
            in_2 <= (others => '0');
        END IF;
        if state1 = 5 and state2 = 5 then
            rst_in <= '0';
            in_1 <= gcd1;
            in_2 <= gcd2;
        else
			in_1 <= (others => '0');
            in_2 <= (others => '0');
            rst_in <= '1';
        end if;
        
    END PROCESS;
    proc3 : fpb PORT MAP(rst_in, clk, go_i, in_1, in_2, gcd3, state3);
    d_o <= gcd3;

    process (state3) 
    begin
        if state3 = 5 then
            done <= '1';
        else 
            done <= '0';
        end if;
    end process;
END behavioral;