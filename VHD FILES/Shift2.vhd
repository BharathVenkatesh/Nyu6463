library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 	
entity shift2 is
Port ( 
data : in STD_LOGIC_vector(31 downto 0);
shifted: out STD_LOGIC_VECTOR(31 DOWNTO 0));
end shift2;
 
architecture rtl of shift2 is
begin
	shifted<= data(29 downto 0) & "00";
end rtl;