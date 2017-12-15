library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Mux_2_32bit is
		Port ( in0 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in1 : in  STD_LOGIC_VECTOR(31 downto 0);
			    sel : in STD_LOGIC;
             output : out  STD_LOGIC_VECTOR(31 downto 0));
end Mux_2_32bit;
architecture rtl of Mux_2_32bit is
begin
output <= in1 WHEN (sel = '1') ELSE in0;
end rtl;