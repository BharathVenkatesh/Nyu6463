-- NYU 6463 Processor
-- Anurag Marwah, Nikhil Shinde, Bharath Venkatesh, Jahanvi Vilas Karjinni, Rushikesh Kulkarni
-- am8482 | nrs407 | bv557 | jvk249 | rk3103
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER


ENTITY nyu6463 IS
 PORT  (
  clr: IN STD_LOGIC;  -- asynchronous reset
  CLK: IN STD_LOGIC;   -- Clock signal
  ukey: IN STD_LOGIC_VECTOR(127 downto 0); --Master din
  din: IN STD_LOGIC_VECTOR(63 downto 0);
  Dout1:OUT STD_LOGIC_VECTOR(31 downto 0);
  Dout2:OUT STD_LOGIC_VECTOR(31 downto 0);
  Key_rdy : OUT STD_LOGIC;
  Processor_switch: IN STD_LOGIC;
  Enc_Dec_switch : IN STD_LOGIC;
  Keygen_switch : IN STD_LOGIC
  --outvalue:OUT STD_LOGIC_VECTOR(31 downto 0)
  );
END nyu6463;

ARCHITECTURE rtl OF nyu6463 IS

	COMPONENT fetch
	PORT	(
			PC: IN STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter
			Instruction: OUT STD_LOGIC_VECTOR(31 downto 0)   -- Instruction
			);
	END COMPONENT;
	
	COMPONENT decode
	PORT  (
			Opcode: IN STD_LOGIC_VECTOR(5 downto 0);  -- Opcode
			FunctionCode: IN STD_LOGIC_VECTOR(5 downto 0);  -- Function Code
			ControlWord: OUT STD_LOGIC_VECTOR(31 downto 0)   -- Control Word
			);
	END COMPONENT;
	
	COMPONENT RegisterFile
	PORT 		( read_address_rs : in STD_LOGIC_VECTOR(4 downto 0);
				  read_address_rt : in STD_LOGIC_VECTOR (4 downto 0);
				  write_address: in STD_LOGIC_VECTOR (4 downto 0);
				  write_data : in STD_LOGIC_VECTOR (31 downto 0);				
				  write_enable : in STD_LOGIC;
				  clk : in STD_LOGIC;
				  clr : in STD_LOGIC;
				  out_data_rs : out STD_LOGIC_VECTOR (31 downto 0);
				  out_data_rt: out STD_LOGIC_VECTOR (31 downto 0));
	END COMPONENT;
	
	COMPONENT sign_extend
	PORT ( data : in STD_LOGIC_vector(15 downto 0);
			 SignExt : out STD_LOGIC_vector(31 downto 0));
	END COMPONENT;
	
	COMPONENT ALU
    Port ( op1 : in  STD_LOGIC_VECTOR (31 downto 0);
           op2 : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
           ALUResult : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT DataMem 
	PORT	( Address : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
           WriteData : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
           WriteEnable : in  STD_LOGIC;
			  Clk : in STD_LOGIC;
			  clr : in STD_LOGIC;
           ReadData : out  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  ukey:in std_logic_vector(127 downto 0); 
			  din: in std_logic_vector(63 downto 0); 
			  Processor_switch : in std_logic;
			  Doutmem48,Doutmem49 : out  STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Mux_2_5bit
	Port ( 	in0 : in  STD_LOGIC_VECTOR(4 downto 0);
				in1 : in  STD_LOGIC_VECTOR(4 downto 0);
			   sel : in STD_LOGIC;
            output : out  STD_LOGIC_VECTOR(4 downto 0));
	END COMPONENT;
	COMPONENT Mux_2_32bit
	Port (	in0 : in  STD_LOGIC_VECTOR(31 downto 0);
				in1 : in  STD_LOGIC_VECTOR(31 downto 0);
			   sel : in STD_LOGIC;
            output : out  STD_LOGIC_VECTOR(31 downto 0));
	END COMPONENT;
	COMPONENT adder32
	PORT ( in0 : in STD_LOGIC_VECTOR(31 downto 0);
			 in1 : in STD_LOGIC_VECTOR(31 downto 0);
			 output: out STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	COMPONENT shift2
	PORT ( data : in STD_LOGIC_vector(31 downto 0);
			 shifted: out STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	 
	COMPONENT Mux_4_32bit
		Port ( in0 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in1 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in2 : in  STD_LOGIC_VECTOR(31 downto 0);
				 in3 : in  STD_LOGIC_VECTOR(31 downto 0);
			    sel : in STD_LOGIC_VECTOR(1 downto 0);
             output : out  STD_LOGIC_VECTOR(31 downto 0));
	END COMPONENT;

	COMPONENT Mux_4_1bit
		Port ( in0 : in  STD_LOGIC;
				 in1 : in  STD_LOGIC;
				 in2 : in  STD_LOGIC;
				 in3 : in  STD_LOGIC;
			    sel : in STD_LOGIC_VECTOR(1 downto 0);
             output : out  STD_LOGIC);
	END COMPONENT;
	
  --round counter
  --SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL PC: STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter
  SIGNAL PCplus4: STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter + 4
  SIGNAL PCBranch: STD_LOGIC_VECTOR(31 downto 0);  -- PC Branch Address
  SIGNAL BranchCondition: STD_LOGIC; -- Branch Condition for I-type Branch Instructions
  --SIGNAL PCJump: STD_LOGIC_VECTOR(31 downto 0);  -- PC Jump Address
  SIGNAL NextPC: STD_LOGIC_VECTOR(31 downto 0);  -- Next value of PC
  
  SIGNAL Instruction: STD_LOGIC_VECTOR(31 downto 0); -- Instruction
  SIGNAL ControlWord: STD_LOGIC_VECTOR(31 downto 0); -- Control Word
  
  SIGNAL WriteReg: STD_LOGIC_VECTOR(4 downto 0); -- Reg File Write Reg
  SIGNAL RD1,RD2: STD_LOGIC_VECTOR(31 downto 0); -- Reg File Read Registers
  SIGNAL SignImm: STD_LOGIC_VECTOR(31 downto 0); -- Sign Extended Immediate Data
  SIGNAL ShiftedSignImm: STD_LOGIC_VECTOR(31 downto 0); -- Shifted Sign Extended Immediate Data
  
  SIGNAL ALUSrcB: STD_LOGIC_VECTOR(31 downto 0); -- ALU Source B Register
  SIGNAL ALUResult: STD_LOGIC_VECTOR(31 downto 0); -- ALU Result
  SIGNAL Zero: STD_LOGIC; -- Zero Flag for ALU Result
  
  SIGNAL ReadData: STD_LOGIC_VECTOR(31 downto 0); -- ReadData
  SIGNAL Result: STD_LOGIC_VECTOR(31 downto 0); -- Result for WB Stage
  
  TYPE  StateType IS (ST_INIT, --PC based on switches
							ST_KEYGEN,
							ST_ENC,
							ST_DEC
							);
-- RC5 state machine has four states: idle, pre_round, round and ready
SIGNAL  state:   StateType;

BEGIN

	F1: fetch PORT MAP (PC=>PC,Instruction=>Instruction);
	D1: decode PORT MAP ( 	Opcode=>Instruction(31 downto 26),FunctionCode=>Instruction(5 downto 0),
									ControlWord=>ControlWord);
	RF: RegisterFile PORT MAP ( read_address_rs=>Instruction(25 downto 21), 
										read_address_rt=>Instruction(20 downto 16),
										write_address=>WriteReg,write_data=>Result,
										write_enable=>ControlWord(4),clk=>clk,clr=>clr,
										out_data_rs=>RD1,out_data_rt=>RD2);

	Mux1: Mux_2_5bit PORT MAP ( in0=>Instruction(15 downto 11),in1=>Instruction(20 downto 16),
										sel=>ControlWord(5),output=>WriteReg);
										
	Imm: sign_extend PORT MAP ( data=>Instruction(15 downto 0),SignExt=>SignImm);
	Mux2: Mux_2_32bit PORT MAP ( in0=>RD2,in1=>SignImm,sel=>ControlWord(3),output=>ALUSrcB);
  
	ALU1: ALU PORT MAP ( op1=>RD1,op2=>ALUSrcB,ALUControl=>ControlWord(2 downto 0),
								ALUResult=>ALUResult,Zero=>Zero);
  
	DM: DataMem PORT MAP ( Address=>ALUResult(5 downto 0),WriteData=>RD2,WriteEnable=>ControlWord(6),
								 clk=>clk,clr=>clr,ReadData=>ReadData,ukey=>ukey,din=>din,Processor_switch=>Processor_switch, 
								 Doutmem48=>Dout1,Doutmem49=>Dout2);

	Mux3: Mux_2_32bit PORT MAP ( in0=>ALUResult,in1=>ReadData,
										sel=>ControlWord(7),output=>Result);
	
	PC_Plus_4: adder32 PORT MAP ( in0=>PC,in1=>x"00000004",output=>PCplus4);
	Shiftby2: shift2 PORT MAP ( data=>SignImm,shifted=>ShiftedSignImm);
	PC_Branch: adder32 PORT MAP ( in0=>ShiftedSignImm,in1=>PCplus4,output=>PCBranch);
	Branch_Logic: Mux_4_1bit PORT MAP (	in0=>'0',
													in1=>((NOT zero) AND ALUResult(15)),
													in2=>(zero),
													in3=>(NOT(zero)),
													sel=>Instruction(27 downto 26),output=>BranchCondition);
	Next_PC: Mux_4_32bit PORT MAP ( 	in0=>PCplus4,in1=>PCBranch,
												in2=>(PCplus4(31 downto 28)&Instruction(25 downto 0)&"00"),in3=>PC,
												sel=>ControlWord(9)&(ControlWord(10) OR (ControlWord(8) AND BranchCondition)),
												output=>NextPC);
	--outvalue<=ReadData;
-- state machine for PC:
	PROCESS (Processor_switch,Enc_Dec_switch,Keygen_switch) BEGIN
		IF (Processor_switch= '1') THEN state<=ST_INIT;
		ELSIF (Keygen_switch= '1') THEN state<=ST_KEYGEN;
		ELSIF (Enc_Dec_switch='0') THEN state<=ST_ENC;
		ELSIF (Enc_Dec_switch= '1') THEN state<=ST_DEC;
		END IF;
	END PROCESS;
	
--normal pc process
	PROCESS (state,clk,clr) BEGIN
		--IF(clk'EVENT AND clk='1')
		IF(state = ST_INIT) THEN
			PC <= x"00000000";
		ELSIF (state = ST_KEYGEN) THEN 
			IF (clr='1') THEN PC <= x"000001D4";   
			ELSIF (rising_edge(clk)) THEN 
				PC <= NextPC;
				IF (PC=x"000002bc") THEN Key_rdy <= '1'; ELSE Key_rdy <= '0'; END IF;
			END IF;		
		ELSIF (state = ST_ENC) THEN
			IF (clr='1') THEN PC <= x"00000320";   
			ELSIF (rising_edge(clk)) THEN PC <= NextPC; END IF;
		ELSIF (state = ST_DEC) THEN
			IF (clr='1') THEN PC <= x"0000044C"; 
			ELSIF (rising_edge(clk)) THEN PC <= NextPC; END IF;
		END IF;
	END PROCESS;
	
--		-- 4 bit counter
--		PROCESS(clr, clk)  
--		BEGIN
--		  IF(clr='0') THEN 
--			i_cnt<="0000";
--		  ELSIF(rising_edge(clk)) THEN
--				 IF(i_cnt="1111") THEN
--					i_cnt<="0000";
--				 ELSE
--					i_cnt<=i_cnt+'1';
--				 END IF;
--		  END IF;
--		END PROCESS;
--		PC(31 downto 6)<="00000000000000000000000000";
--		PC(5 downto 2)<=i_cnt(3 downto 0);
--		PC(1 downto 0)<="00";
END rtl;

