library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity division_example is
    Port ( dividend : in integer; --Multiplier
           divisor : in integer; --GCD
           quotient : out integer); --Hasil
end division_example;

architecture Behavioral of division_example is
    signal dividend_signed, divisor_signed : INTEGER;
    signal quotient_real : REAL;
begin
    quotient_real <= REAL(dividend) / REAL(divisor);
    -- Convert real numbers back to integers
    quotient <= integer (quotient_real);
end Behavioral;
