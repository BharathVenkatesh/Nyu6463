library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMem is
    Port ( Address : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
           WriteData : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           WriteEnable : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  clr : in STD_LOGIC;
           ReadData : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  ukey:in std_logic_vector(127 downto 0); 
			  din: in std_logic_vector(63 downto 0); 
			  Processor_switch : in std_logic;
			  Doutmem48,Doutmem49 : out  STD_LOGIC_VECTOR(31 DOWNTO 0)
			  );
end DataMem;

architecture Behavioral of DataMem is
Type RAM is array (0 to 63) of std_logic_vector(31 downto 0);
	--signal myRam : RAM; := ((others => (others => '0')));
	signal myRam: RAM := RAM'(
	
--	
----	
									  x"00000000", x"00000000", x"00000000", x"00000000", 
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000"
									  
--									  
--									  x"00000000", x"00000000", x"00000000", x"00000000", --0
--									  x"00000000", x"00000000", x"00000000", x"00000000", --4
--									  x"00000000", x"00000000", x"00000000", x"00000000", --8
--									  x"00000000", x"00000000", x"00000000", x"00000000", --12
--									  x"00000000", x"00000000", x"00000000", x"00000000", 									  
--									X"9BBBD8C8", X"1A37F7FB", X"46F8E8C5",
--							  X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
--								X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99",
--								X"2799A4DD", X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249",
--								X"61A78BB8", X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A",
--								X"43192304", X"F6CC1431", X"65046380",
--									   x"00000000", x"00000000", x"00000000", --20
--									  
--									  x"00000000", x"00000000", x"00000000", x"00000000", --24
--									  x"00000000", x"00000000", x"00000000", x"00000000", --28
--									  x"00000000", x"00000000", x"00000000", x"00000000", --32
--									  x"00000000", x"00000000",x"00000000"--0
								  );
begin
	process(Processor_switch,WriteEnable,clr,clk,WriteData,Address) begin
	if(Processor_switch='1') then
		myRam(10) <= ukey(31 downto 0);
		myRam(11) <= ukey(63 downto 32);
		myRam(12) <= ukey(95 downto 64);
		myRam(13) <= ukey(127 downto 96); 
		myRam(46) <= din(31 downto 0);
		myRam(47) <= din(63 downto 32);
	elsif(rising_edge(clk)) then
--			if (clr='1') then 
--				myRAM <= (others => (others => '0')); -- Clear RAM
--			else
				if(WriteEnable = '1') then	
					myRam(CONV_INTEGER(Address)) <= WriteData; -- Write Operation
				end if;
			end if;
		--end if;
	end process;
	
	ReadData <= myRam(CONV_INTEGER(Address)); -- Read Operation
	Doutmem48<=myRam(48); --Dout value for displaying
	Doutmem49<=myRam(49); --Dout value for displaying
	
end Behavioral;

