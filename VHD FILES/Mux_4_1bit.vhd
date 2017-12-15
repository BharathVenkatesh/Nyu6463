library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Mux_4_1bit is
		Port ( in0 : in  STD_LOGIC;
				 in1 : in  STD_LOGIC;
				 in2 : in  STD_LOGIC;
				 in3 : in  STD_LOGIC;
			    sel : in STD_LOGIC_VECTOR(1 downto 0);
             output : out  STD_LOGIC);
end Mux_4_1bit;
architecture rtl of Mux_4_1bit is
begin
	WITH sel SELECT
		output <=	in0 WHEN "00",
						in1 WHEN "01",
						in2 WHEN "10",
						in3 WHEN "11";
end rtl;