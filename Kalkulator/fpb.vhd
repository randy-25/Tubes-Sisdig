LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY fpb IS
    PORT (
        rst, clk, go_i : IN STD_LOGIC;
        x_input, y_input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        d_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        state : OUT INTEGER
    );
END ENTITY;

ARCHITECTURE behavioral OF fpb IS
    COMPONENT fsm IS
        PORT (
            rst, clk, go, compared, equal_x : IN STD_LOGIC;
            go_o, enable, modeX, modeY : OUT STD_LOGIC;
            cstate : OUT INTEGER
        );
    END COMPONENT;

    COMPONENT mux IS
        PORT (
            input_0, input_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            reset, clock, mode : IN STD_LOGIC;
            output_f : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT subtractor IS
        PORT (
            reset, clock, compared : IN STD_LOGIC;
            x_i, y_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            d_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT comparator IS
        PORT (
            reset, clock : IN STD_LOGIC;
            x_in, y_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            d_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT regis IS
        PORT (
            reset, clock, enable : IN STD_LOGIC;
            x_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            x_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT equal IS
        PORT (
            reset, clock : IN STD_LOGIC;
            x_in, y_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            eq_out : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL x_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL y_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL compared, equal_o, go_o, enable, modeX, modeY : STD_LOGIC;
    SIGNAL result : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sub_o, ixmux, iymux, xmux, ymux : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL xreg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL yreg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cstate : INTEGER;

BEGIN

    PROCESS (x_input, y_input, x_i, y_i)
    BEGIN
        x_i <= "000000000000000000000000" & x_input;
        y_i <= "000000000000000000000000" & y_input;
    END PROCESS;
    
    -- control
    fsmControl : fsm PORT MAP(rst, clk, go_i, compared, equal_o, go_o, enable, modeX, modeY, cstate);

    --datapath
    initialXMUX : mux PORT MAP(x_i,xmux, rst, clk, go_o, ixmux);
    initialYMUX : mux PORT MAP(y_i, ymux, rst, clk, go_o, iymux);
    X_MUX : mux PORT MAP(xreg, sub_o, rst, clk, modeX, xmux);
    Y_MUX : mux PORT MAP(yreg, sub_o, rst, clk, modeY, ymux);
    X_REG : regis PORT MAP(rst, clk, enable, ixmux, xreg);
    Y_REG : regis PORT MAP(rst, clk, enable, iymux, yreg);
    COMP : comparator PORT MAP(rst, clk, xreg, yreg, compared);
    SUB : subtractor PORT MAP(rst, clk, compared, xreg, yreg, sub_o);
    EQ : equal PORT MAP(rst, clk, xreg, yreg, equal_o);
    out_GCD : regis PORT MAP(rst, clk, equal_o, xreg, result);

    d_o <= result(7 downto 0);
    state <= cstate;

END behavioral;