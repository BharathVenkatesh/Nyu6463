library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
		 port ( read_address_rs : in STD_LOGIC_VECTOR(4 downto 0);
				  read_address_rt : in STD_LOGIC_VECTOR (4 downto 0);
				  write_address: in STD_LOGIC_VECTOR (4 downto 0);
				  write_data : in STD_LOGIC_VECTOR (31 downto 0);				
				  write_enable : in STD_LOGIC;
				  clk : in STD_LOGIC;
				  clr : in STD_LOGIC;
				  out_data_rs : out STD_LOGIC_VECTOR (31 downto 0);
				  out_data_rt: out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
	type RAM is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	SIGNAL register_file: RAM:= (others => (others => '0'));
	
begin

	process (write_enable, clr, write_address, write_data, clk) begin
		if (rising_edge(clk)) then
			if (clr='1') then 
				register_file <= (others => (others => '0'));
			else
				if(write_enable='1') then 
					register_file(CONV_INTEGER(write_address)) <= write_data;
				end if;
			end if;
		end if;	
	end process;
	out_data_rs <= register_file(CONV_INTEGER(read_address_rs));
	out_data_rt <= register_file(CONV_INTEGER(read_address_rt));

end Behavioral;



