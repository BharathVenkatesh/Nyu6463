library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Mux_4_32bit is
		Port ( in0 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in1 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in2 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in3 : in  STD_LOGIC_VECTOR(31 downto 0);
			    sel : in STD_LOGIC_VECTOR(1 downto 0);
             output : out  STD_LOGIC_VECTOR(31 downto 0));
end Mux_4_32bit;
architecture rtl of Mux_4_32bit is
	COMPONENT Mux_2_32bit
		Port ( in0 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in1 : in  STD_LOGIC_VECTOR(31 downto 0);
			    sel : in STD_LOGIC;
             output : out  STD_LOGIC_VECTOR(31 downto 0));
	END COMPONENT;
	SIGNAL R1,R2: STD_LOGIC_VECTOR(31 downto 0);
begin
	M1: Mux_2_32bit PORT MAP (in0,in1,sel(0),R1);
	M2: Mux_2_32bit PORT MAP (in2,in3,sel(0),R2);
	M3: Mux_2_32bit PORT MAP (R1,R2,sel(1),output);
end rtl;