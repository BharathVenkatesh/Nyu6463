LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; --use CONV_INTEGER

ENTITY decode IS
 PORT  (
  Opcode: IN STD_LOGIC_VECTOR(5 downto 0);  -- Opcode
  FunctionCode: IN STD_LOGIC_VECTOR(5 downto 0);  -- Function Code
  ControlWord: OUT STD_LOGIC_VECTOR(31 downto 0)   -- Control Word
  );
END decode;

ARCHITECTURE rtl OF decode IS
  
-- 	CONTROL WORD - FORMAT
--		10			9		 	8			7				6				5			4				3			2			1			0
-- 	Halt	Jtype		Branch	MemtoReg		MemWrite		RegDst	RegWrite		ALUSrc		ALUControl [2:0]

	SIGNAL Halt,Jtype,Branch,MemtoReg,MemWrite,RegDst,RegWrite,ALUSrc: STD_LOGIC; -- Various Control Signals
	SIGNAL ALUControl: STD_LOGIC_VECTOR(2 downto 0); -- ALU Control Signal
	
	BEGIN
	-- Write Back Reg Source
	MemtoReg <=	'1' WHEN (Opcode=x"07") ELSE '0'; -- Load Instruction
	
	-- Data Memory Write Enable
	MemWrite <=	'1' WHEN (Opcode=x"08") ELSE '0'; -- Store Instruction
	
	-- isBranch?
	Branch <= '1' WHEN (Opcode=x"09" OR Opcode=x"0A" OR Opcode=x"0B") ELSE '0'; -- I-type Branch Instruction
	
	-- J type Instruction
	Jtype <= '1' WHEN (Opcode=x"0C" OR Opcode=x"3F") ELSE '0'; -- Jump or Halt
	
	-- Halt Instruction
	Halt <= '1' WHEN (Opcode=x"3F") ELSE '0'; -- Halt Instruction
	
	-- ALU Control
	ALUControl(2 downto 0) <=	"001" WHEN (Opcode=x"01" OR (Opcode=x"00" AND FunctionCode=x"10") OR Opcode=x"07" OR Opcode=x"08") ELSE -- Add Operation
										"010" WHEN (Opcode=x"02" OR (Opcode=x"00" AND FunctionCode=x"11") OR Branch='1') ELSE -- Sub Operation
										"011" WHEN (Opcode=x"03" OR (Opcode=x"00" AND FunctionCode=x"12")) ELSE -- AND Operation
										"100" WHEN (Opcode=x"04" OR (Opcode=x"00" AND FunctionCode=x"13")) ELSE -- OR Operation
										"101" WHEN (Opcode=x"00" AND FunctionCode=x"14") ELSE -- NOR Operation
										"110" WHEN (Opcode=x"05") ELSE -- Shift Left Operation
										"111" WHEN (Opcode=x"06") ELSE -- Shift Right Operation
										"000"; -- Default Case
		
	-- ALU Reg 2 Source: 1 when immediate instruction or sw
	ALUSrc <= '1' WHEN (	Opcode=x"01" OR Opcode=x"02" OR Opcode=x"03" OR Opcode=x"04" OR 
								Opcode=x"05" OR Opcode=x"06" OR Opcode=x"07" OR Opcode=x"08")
					  ELSE '0';
	
	-- RegFile Write Address: 1 when immediate instruction
	RegDst <= '1' WHEN (	Opcode=x"01" OR Opcode=x"02" OR Opcode=x"03" OR Opcode=x"04" OR 
								Opcode=x"05" OR Opcode=x"06" OR Opcode=x"07")
					  ELSE '0';
					  
	-- RegFile Write Enable
	RegWrite <= '1' WHEN (	Opcode=x"01" OR Opcode=x"02" OR Opcode=x"03" OR Opcode=x"04" OR 
									Opcode=x"05" OR Opcode=x"06" OR Opcode=x"07" OR (Opcode=x"00" AND 
								 (FunctionCode=x"10" OR FunctionCode=x"11" OR FunctionCode=x"12" OR
								  FunctionCode=x"13" OR FunctionCode=x"14")))
						 ELSE '0';
	
	-- Control Word
	ControlWord <= (	"000000000000000000000" &
							Halt & Jtype & Branch & 
							MemtoReg & MemWrite & 
							RegDst & RegWrite & 
							ALUSrc & ALUControl (2 downto 0));
END rtl;