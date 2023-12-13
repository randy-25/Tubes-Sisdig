-- Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
-- Entity
ENTITY sev_seg IS
    PORT (
        clk : IN STD_LOGIC;
        mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        selector : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ss : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END sev_seg;
ARCHITECTURE behavior OF sev_seg IS
    SIGNAL clockdiv : INTEGER := 0;
    SIGNAL selector : INTEGER := 0;
BEGIN
    --Counter Per Segmen
    PROCESS (clockdiv, clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            clockdiv <= clockdiv + 1;
            IF (clockdiv > 25000) THEN
                clockdiv <= 0;
                selector <= selector + 1;
                IF selector > 3 THEN
                    selector <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    --Pemilihan Selector Segmen
    PROCESS (selector)
    BEGIN
        CASE selector IS
            WHEN 0 => selector <= "0111"; --segmen ujung kanan
            WHEN 1 => selector <= "1011";
            WHEN 2 => selector <= "1101";
            WHEN 3 => selector <= "1110"; --segmen ujung kiri
            WHEN OTHERS => selector <= "1111";
        END CASE;
    END PROCESS;
    
    -- Digit pada segmen
    PROCESS (clk)
    BEGIN
        CASE selector IS
            WHEN 0 =>
                CASE mode IS
                    WHEN "00" => ss <= "10001110";
                    WHEN "01" => ss <= "10001001";
                    WHEN "10" => ss <= "10001110";
                    WHEN OTHERS => ss <= "11111111";
                END CASE;
            WHEN 1 =>
                CASE mode IS
                    WHEN "00" => ss <= "10001100";
                    WHEN "01" => ss <= "10001100";
                    WHEN "10" => ss <= "11001000";
                    WHEN OTHERS => ss <= "11111111";
                END CASE;
            WHEN 2 =>
                CASE mode IS
                    WHEN "00" => ss <= "10000000";
                    WHEN "01" => ss <= "10001001";
                    WHEN "10" => ss <= "10001001";
                    WHEN OTHERS => ss <= "11111111";
                END CASE;
            WHEN 3 =>
                CASE mode IS
                    WHEN "00" => ss <= "11111111";
                    WHEN "01" => ss <= "11111111";
                    WHEN "10" => ss <= "11111111";
                    WHEN OTHERS => ss <= "11111111";
                END CASE;
            WHEN OTHERS =>
        END CASE;
    END PROCESS;

END behavior;