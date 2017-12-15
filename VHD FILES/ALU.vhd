
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.std_logic_signed.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity ALU is
    Port ( op1 : in  STD_LOGIC_VECTOR (31 downto 0);
           op2 : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
           ALUResult : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal Result:signed(31 downto 0);	
signal x,srcA,srcB: signed(31 downto 0) := (others => '0'); 
signal LeftShiftOutput,RightShiftOutput: signed(31 downto 0);
begin

SrcA <= signed(op1);
SrcB <= signed(op2);
x<="00000000000000000000000000000000";
--process(ALUControl)
--begin

--Lshift: leftrotate port map(SourceA,SourceB,LeftShiftOutput);
--Rshift: rightrotate port map(SourceA,SourceB,RightShiftOutput);

--SourceA<=SrcA;
--SourceB<=SrcB;

--if (ALUControl="101") then 
--	Lshift: leftrotate port map(SrcA,SrcB,LeftShiftOutput);
--	ALUResult<=LeftShiftOutput;
--elsif(ALUcontrol="110") then
--	Rshift: rightrotate port map(SrcA,SrcB,RightSshiftOutput);
--	ALUResult<=RightShiftOutput;
--end if;
--end process;

with ALUControl(2 downto 0) select
Result<= (SrcA) + (SrcB)  when "001",
			(SrcA) - (SrcB) when "010",
			(SrcA) and (SrcB) when "011",
			(SrcA) or (SrcB) when "100",
			(SrcA) nor (SrcB) when "101",
			LeftShiftOutput when "110",
			RightShiftOutput when "111",
			x"00000000" when "000";
	
Zero <= '1' when Result="00000000000000000000000000000000"
else '0';

with SrcB(4 downto 0) select
	LeftShiftOutput<=SrcA(30 DOWNTO 0) & x(31) WHEN "00001",
	  SrcA(28 DOWNTO 0) & x(31 DOWNTO 29) WHEN "00011",
	  SrcA(27 DOWNTO 0) & x(31 DOWNTO 28) WHEN "00100",
	  SrcA(26 DOWNTO 0) & x(31 DOWNTO 27) WHEN "00101",
	  SrcA(25 DOWNTO 0) & x(31 DOWNTO 26) WHEN "00110",
	  SrcA(24 DOWNTO 0) & x(31 DOWNTO 25) WHEN "00111",
	  SrcA(23 DOWNTO 0) & x(31 DOWNTO 24) WHEN "01000",
	  SrcA(22 DOWNTO 0) & x(31 DOWNTO 23) WHEN "01001",
	  SrcA(21 DOWNTO 0) & x(31 DOWNTO 22) WHEN "01010",
	  SrcA(20 DOWNTO 0) & x(31 DOWNTO 21) WHEN "01011",
	  SrcA(19 DOWNTO 0) & x(31 DOWNTO 20) WHEN "01100",
	  SrcA(18 DOWNTO 0) & x(31 DOWNTO 19) WHEN "01101",
	  SrcA(17 DOWNTO 0) & x(31 DOWNTO 18) WHEN "01110",
	  SrcA(16 DOWNTO 0) & x(31 DOWNTO 17) WHEN "01111",
	  SrcA(15 DOWNTO 0) & x(31 DOWNTO 16) WHEN "10000",
	  SrcA(14 DOWNTO 0) & x(31 DOWNTO 15) WHEN "10001",
	  SrcA(13 DOWNTO 0) & x(31 DOWNTO 14) WHEN "10010",
	  SrcA(12 DOWNTO 0) & x(31 DOWNTO 13) WHEN "10011",
	  SrcA(11 DOWNTO 0) & x(31 DOWNTO 12) WHEN "10100",
	  SrcA(10 DOWNTO 0) & x(31 DOWNTO 11) WHEN "10101",
	  SrcA(9 DOWNTO 0) & x(31 DOWNTO 10) WHEN "10110",
	  SrcA(8 DOWNTO 0) & x(31 DOWNTO 9) WHEN "10111",
	  SrcA(7 DOWNTO 0) & x(31 DOWNTO 8) WHEN "11000",
	  SrcA(6 DOWNTO 0) & x(31 DOWNTO 7) WHEN "11001",
	  SrcA(5 DOWNTO 0) & x(31 DOWNTO 6) WHEN "11010",
	  SrcA(4 DOWNTO 0) & x(31 DOWNTO 5) WHEN "11011",
	  SrcA(3 DOWNTO 0) & x(31 DOWNTO 4) WHEN "11100",
	  SrcA(2 DOWNTO 0) & x(31 DOWNTO 3) WHEN "11101",
	  SrcA(1 DOWNTO 0) & x(31 DOWNTO 2) WHEN "11110",
	  SrcA(0) & x(31 DOWNTO 1) WHEN "11111",
	  x WHEN OTHERS;

with SrcB(4 downto 0) select
RightShiftOutput <= x(0) & SrcA(31 DOWNTO 1) WHEN "00001",
	  x(1 DOWNTO 0) & SrcA(31 DOWNTO 2) WHEN "00010",
	  x(2 DOWNTO 0) & SrcA(31 DOWNTO 3) WHEN "00011",
	  x(3 DOWNTO 0) & SrcA(31 DOWNTO 4) WHEN "00100",
	  x(4 DOWNTO 0) & SrcA(31 DOWNTO 5) WHEN "00101",
	  x(5 DOWNTO 0) & SrcA(31 DOWNTO 6) WHEN "00110",
	  x(6 DOWNTO 0) & SrcA(31 DOWNTO 7) WHEN "00111",
	  x(7 DOWNTO 0) & SrcA(31 DOWNTO 8) WHEN "01000",
	  x(8 DOWNTO 0) & SrcA(31 DOWNTO 9) WHEN "01001",
	  x(9 DOWNTO 0) & SrcA(31 DOWNTO 10) WHEN "01010",
	  x(10 DOWNTO 0) & SrcA(31 DOWNTO 11) WHEN "01011",
	  x(11 DOWNTO 0) & SrcA(31 DOWNTO 12) WHEN "01100",
	  x(12 DOWNTO 0) & SrcA(31 DOWNTO 13) WHEN "01101",
	  x(13 DOWNTO 0) & SrcA(31 DOWNTO 14) WHEN "01110",
	  x(14 DOWNTO 0) & SrcA(31 DOWNTO 15) WHEN "01111",
	  x(15 DOWNTO 0) & SrcA(31 DOWNTO 16) WHEN "10000",
	  x(16 DOWNTO 0) & SrcA(31 DOWNTO 17) WHEN "10001",
	  x(17 DOWNTO 0) & SrcA(31 DOWNTO 18) WHEN "10010",
	  x(18 DOWNTO 0) & SrcA(31 DOWNTO 19) WHEN "10011",
	  x(19 DOWNTO 0) & SrcA(31 DOWNTO 20) WHEN "10100",
	  x(20 DOWNTO 0) & SrcA(31 DOWNTO 21) WHEN "10101",
	  x(21 DOWNTO 0) & SrcA(31 DOWNTO 22) WHEN "10110",
	  x(22 DOWNTO 0) & SrcA(31 DOWNTO 23) WHEN "10111",
	  x(23 DOWNTO 0) & SrcA(31 DOWNTO 24) WHEN "11000",
	  x(24 DOWNTO 0) & SrcA(31 DOWNTO 25) WHEN "11001",
	  x(25 DOWNTO 0) & SrcA(31 DOWNTO 26) WHEN "11010",
	  x(26 DOWNTO 0) & SrcA(31 DOWNTO 27) WHEN "11011",
	  x(27 DOWNTO 0) & SrcA(31 DOWNTO 28) WHEN "11100",
	  x(28 DOWNTO 0) & SrcA(31 DOWNTO 29) WHEN "11101",
	  x(29 DOWNTO 0) & SrcA(31 DOWNTO 30) WHEN "11110",
	  x(30 DOWNTO 0) & SrcA(31) WHEN "11111",
	  x WHEN OTHERS;
	  
	  
ALUResult<=STD_LOGIC_VECTOR (Result);
end architecture;