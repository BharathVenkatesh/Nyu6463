----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:04 12/14/2017 
-- Design Name: 
-- Module Name:    FPGA_RC5_TOP_MODULE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FPGA_RC5_TOP_MODULE is
	Port (  clk : in  STD_LOGIC;
			  sw: in STD_LOGIC_VECTOR(15 downto 0);
			  btnc,btnl,btnu: in std_logic;
			  led0: out std_logic;
			  SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0)
		  );
end FPGA_RC5_TOP_MODULE;

architecture Behavioral of FPGA_RC5_TOP_MODULE is

	COMPONENT nyu6463 IS
	 PORT  (
	  clr: IN STD_LOGIC;  -- asynchronous reset
	  CLK: IN STD_LOGIC;   -- Clock signal
	  ukey:IN STD_LOGIC_VECTOR(127 downto 0);
	  din: IN STD_LOGIC_VECTOR(63 downto 0);
	  Dout1:OUT STD_LOGIC_VECTOR(31 downto 0);
	  Dout2:OUT STD_LOGIC_VECTOR(31 downto 0);
	  Key_rdy : OUT STD_LOGIC;
	  Processor_switch : IN STD_LOGIC;
	  Enc_Dec_switch : IN STD_LOGIC;
	  Keygen_switch : IN STD_LOGIC
	  );
	END COMPONENT;
	
	COMPONENT Hex2LED --Converts a 4 bit hex value into the pattern to be displayed on the 7seg
		port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
	END COMPONENT;

	
-- Processor clock signal
signal Processor_clk: std_logic:='0';

-- Signals for interfacing
signal ukey:STD_LOGIC_VECTOR(127 downto 0);
signal din:STD_LOGIC_VECTOR(63 downto 0);
signal Dout1:STD_LOGIC_VECTOR(31 downto 0);
signal Dout2:STD_LOGIC_VECTOR(31 downto 0);
signal Key_rdy : STD_LOGIC;
--signals for 7 segment display
type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;
signal Val : std_logic_vector(3 downto 0) := (others => '0');
signal HexVal: std_logic_vector(31 downto 0);
signal slowCLK: std_logic:='0';
signal i_cnt: std_logic_vector(19 downto 0):=x"00000";

begin


	NYUProcessor: nyu6463 port map (clk=>Processor_clk,clr=>btnc,ukey=> ukey, din=>din, Dout1=> Dout1,
											Dout2=> Dout2, Processor_switch=>sw(10),Enc_Dec_switch=>sw(9),
											Key_rdy=>Key_rdy,Keygen_switch=>sw(11));

-- making Processor clock
process(CLK) begin
	if (rising_edge(CLK)) then
		Processor_clk<=not Processor_clk;
	end if;
end process;


--buttons and switches interface logic
process(sw(15 downto 12),btnl,sw(10))
begin
	if(sw(10) = '1') then
		if(sw(15 downto 12)="0000" and btnl = '1') then ukey(7 downto 0)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0001" and btnl = '1') then ukey(15 downto 8)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0010" and btnl = '1') then ukey(23 downto 16)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0011" and btnl = '1') then ukey(31 downto 24)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0100" and btnl = '1') then ukey(39 downto 32)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0101" and btnl = '1') then ukey(47 downto 40)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0110" and btnl = '1') then ukey(55 downto 48)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0111" and btnl = '1') then ukey(63 downto 56)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1000" and btnl = '1') then ukey(71 downto 64)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1001" and btnl = '1') then ukey(79 downto 72)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1010" and btnl = '1') then ukey(87 downto 80)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1011" and btnl = '1') then ukey(95 downto 88)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1100" and btnl = '1') then ukey(103 downto 96)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1101" and btnl = '1') then ukey(111 downto 104)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1110" and btnl = '1') then ukey(119 downto 112)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="1111" and btnl = '1') then ukey(127 downto 120)<=sw(7 downto 0);
		end if;
	end if;
end process;

process(sw(15 downto 12),btnu,sw(10)) begin
	if(sw(10) = '1') then
		if(sw(15 downto 12)="0000" and btnu = '1') then din(7 downto 0)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0001" and btnu = '1') then din(15 downto 8)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0010" and btnu = '1') then din(23 downto 16)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0011" and btnu = '1') then din(31 downto 24)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0100" and btnu = '1') then din(39 downto 32)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0101" and btnu = '1') then din(47 downto 40)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0110" and btnu = '1') then din(55 downto 48)<=sw(7 downto 0);
		elsif(sw(15 downto 12)="0111" and btnu = '1') then din(63 downto 56)<=sw(7 downto 0);
		end if;
	end if;
end process;



---7 segment display code
-----Creating a slowCLK of 500Hz using the board's 100MHz clock----
process(CLK)
begin
if (rising_edge(CLK)) then
if (i_cnt=x"186A0")then --Hex(186A0)=Dec(100,000)
slowCLK<=not slowCLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
i_cnt<=x"00000";
else
i_cnt<=i_cnt+'1';
end if;
end if;
end process;

-----We use the 500Hz slowCLK to run our 7seg display at roughly 60Hz-----
timer_inc_process : process (slowCLK)
begin
	if (rising_edge(slowCLK)) then
				if(Val="1000") then
				Val<="0001";
				else
				Val <= Val + '1'; --Val runs from 1,2,3,...8 on every rising edge of slowCLK
			end if;
		end if;
	--end if;
end process;

--This select statement selects one of the 7-segment diplay anode(active low) at a time. 
with Val select
	SSEG_AN <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Val select
	SSEG_CA <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
				  NAME(1) when "0010", --See below for the conversion
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;


process(clk,sw(8)) begin
    if(clk'event and clk = '1') then
		if(sw(8) = '0') then
			hexval <= Dout1;
		elsif(sw(8) = '1') then
			 hexval <= Dout2;
		end if;
	end if;
end process;
  
 
--Hex2LED for converting each Hex value to a pattern to be given to the cathode.
CONV1: Hex2LED port map (CLK => CLK, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => CLK, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => CLK, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => CLK, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => CLK, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => CLK, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => CLK, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => CLK, X => HexVal(3 downto 0), Y => NAME(7));

--
led0<=Key_rdy;

end Behavioral;

