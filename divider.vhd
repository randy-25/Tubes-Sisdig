library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port ( multiplier : in integer;
           GCD : in integer;
           hasil : out integer);
end divider;

architecture Behavioral of divider is
begin
    -- Melakukan pembagian dan mendapatkan hasil bagi (KPK) 
    hasil <= multiplier mod GCD ;
end Behavioral;
