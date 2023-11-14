LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE work.ALL;
ENTITY kalkulator IS
    PORT (
        rst, clk, go_i : IN STD_LOGIC;
        x_i, y_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        d_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END kalkulator;
ARCHITECTURE kalkulator_arc OF kalkulator IS
    COMPONENT fsm IS
        PORT (
            rst, clk, proceed : IN STD_LOGIC;
            comparison : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            enable, xsel, ysel, xld, yld : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT mux IS
        PORT (
            rst, sLine : IN STD_LOGIC;
            load, result : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT comparator IS
        PORT (
            rst : IN STD_LOGIC;
            x, y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT subtractor IS
        PORT (
            rst : IN STD_LOGIC;
            cmd : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            x, y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            xout, yout : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT regis IS
        PORT (
            rst, clk, load : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL xld, yld, xsel, ysel, enable : STD_LOGIC;
    SIGNAL comparison : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL xsub, ysub, xmux, ymux, xreg, yreg : STD_LOGIC_VECTOR(3
    DOWNTO 0);
BEGIN
    -- FSM controller 
    TOFSM : fsm PORT MAP(
        rst, clk, go_i, comparison,
        enable, xsel, ysel, xld, yld);
    -- Datapath 
    X_MUX : mux PORT MAP(rst, xsel, x_i, xsub, xmux);
    Y_MUX : mux PORT MAP(rst, ysel, y_i, ysub, ymux);
    X_REG : regis PORT MAP(rst, clk, xld, xmux, xreg);
    Y_REG : regis PORT MAP(rst, clk, yld, ymux, yreg);
    U_COMP : comparator PORT MAP(
        rst, xreg, yreg, comparison
    );
    X_SUB : subtractor PORT MAP(
        rst, comparison, xreg, yreg,
        xsub, ysub);
    OUT_REG : regis PORT MAP(
        rst, clk, enable, xsub, result
    );
    d_o <= result;
END kalkulator_arc;