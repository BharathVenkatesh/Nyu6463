library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_extend is
Port ( 
data : in STD_LOGIC_vector(15 downto 0);
SignExt : out STD_LOGIC_vector(31 downto 0));
end sign_extend;
 
architecture Behavioral of sign_extend is
begin
	SignExt<= (x"0000" & data(15 downto 0)) WHEN (data(15)='0') ELSE
					(x"FFFF" & data(15 downto 0));
end Behavioral; 