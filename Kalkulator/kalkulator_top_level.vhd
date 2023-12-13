LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY kalkulator_top_level IS
    PORT (
        clk, rst, go_i : IN STD_LOGIC;
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        fpb_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        kpk_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        done : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behavioral OF kalkulator_top_level IS
    COMPONENT kalkulatorFPB IS
        PORT (
            clk, rst, go_i : IN STD_LOGIC;
            a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            d_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT kalkulatorKPK IS
        PORT (
            clk, rst, go_i : IN STD_LOGIC;
            a_i, b_i, c_i, d_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            d_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL fpb_o : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL kpk_o : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL doneFPB, doneKPK : STD_LOGIC;

BEGIN
    fpb : kalkulatorFPB PORT MAP(clk, rst, go_i, a_i, b_i, c_i, d_i, fpb_o, doneFPB);
    kpk : kalkulatorKPK PORT MAP(clk, rst, go_i, a_i, b_i, c_i, d_i, kpk_o, doneKPK);
    PROCESS (mode, fpb_o, kpk_o, doneFPB, doneKPK)
    BEGIN
        IF mode = "00" THEN
            fpb_out <= fpb_o;
            kpk_out <= (OTHERS => 'Z');
            IF doneFPB = '1' THEN
                done <= '1';
            ELSE
                done <= '0';
            END IF;
        ELSIF mode = "01" THEN
            fpb_out <= (OTHERS => 'Z');
            kpk_out <= kpk_o;
            IF doneKPK = '1' THEN
                done <= '1';
            ELSE
                done <= '0';
            END IF;
        ELSIF mode = "10" THEN
            fpb_out <= fpb_o;
            kpk_out <= kpk_o;
            IF doneFPB = '1' AND doneKPK = '1' THEN
                done <= '1';
            ELSE
                done <= '0';
            END IF;
        ELSIF mode = "11" THEN
            fpb_out <= (OTHERS => 'Z');
            kpk_out <= (OTHERS => 'Z');
            done <= '0';
        ELSE
			fpb_out <= (OTHERS => 'Z');
			kpk_out <= (OTHERS => 'Z');
			done <= '0';
        END IF;
    END PROCESS;
END behavioral;