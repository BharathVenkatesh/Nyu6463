library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 	
entity adder32 is
Port ( 
in0 : in STD_LOGIC_VECTOR(31 downto 0);
in1 : in STD_LOGIC_VECTOR(31 downto 0);
output: out STD_LOGIC_VECTOR(31 DOWNTO 0));
end adder32;
 
architecture rtl of adder32 is
begin
	output<= in1 + in0;
end rtl;