LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Control IS 
	PORT(
		SIGNAL Opcode			: IN 		STD_LOGIC_VECTOR(5 DOWNTO 0);
		SIGNAL clock, reset	: IN 		STD_LOGIC;
		
		SIGNAL PCWrite			: OUT 	STD_LOGIC;
		SIGNAL PCWriteCond	: OUT 	STD_LOGIC;
		SIGNAL IorD				: OUT 	STD_LOGIC;
		SIGNAL MemRead			: OUT 	STD_LOGIC;
		SIGNAL MemWrite		: OUT 	STD_LOGIC;
		SIGNAL IRWrite			: OUT 	STD_LOGIC;
		SIGNAL MemtoReg		: OUT 	STD_LOGIC;
		SIGNAL PCSource		: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL ALUSrcA			: OUT 	STD_LOGIC;
		SIGNAL ALUSrcB			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL RegWrite		: OUT 	STD_LOGIC;
		SIGNAL ALUOp			: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL RegDst			: OUT		STD_LOGIC);
		
END Control;

ARCHITECTURE behavior OF Control IS
	TYPE State_type IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
	SIGNAL State 	: State_type;
	
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL rising_edge(clock);
		IF reset = '1' THEN
			State <= S0;
		ELSE
			CASE State IS
				WHEN S0 =>
					PCWrite 		<= '1';
					MemRead 		<= '1';
					IRWrite 		<= '1';
					ALUSrcB(0) 	<= '1';
					State 		<= S1;
				WHEN S1 =>
					IF ((Opcode = "100011") OR (Opcode = "101011")) THEN
						ALUSrcB(0) 	<= '1';
						ALUSrcB(1) 	<= '1';
						State <= S2;
					ELSIF Opcode = "000000" THEN
						ALUSrcB(0) 	<= '1';
						ALUSrcB(1) 	<= '1';
						State 		<= S6;
					ELSIF Opcode = "000100" THEN
						ALUSrcB(0) 	<= '1';
						ALUSrcB(1) 	<= '1';
						State 		<= S8;
					ELSIF Opcode = "000010" THEN
						ALUSrcB(0) 	<= '1';
						ALUSrcB(1) 	<= '1';
						State 		<= S9;
					END IF;
				WHEN S2 =>
					IF Opcode = "100011" THEN
						ALUSrcB(1) 	<= '1';
						ALUSrcA	 	<= '1';
						State 		<= S3;
					ELSIF Opcode = "101011" THEN
						ALUSrcB(1) 	<= '1';
						ALUSrcA	 	<= '1';
						State 		<= S5;
					END IF;
				WHEN S3 =>
					IorD		<= '1';
					MemRead	<= '1';
					State 	<= S4;
				WHEN S4 =>
					MemtoReg	<= '1';
					RegWrite	<= '1';
					State 	<= S0;
				WHEN S5 =>
					IorD		<= '1';
					MemWrite	<= '1';
					State 	<= S0;
				WHEN S6 =>
					AluOp(1)	<= '1';
					AluSrcA	<= '1';
					State 	<= S7;
				WHEN S7 =>
					RegWrite	<= '1';
					RegDst	<= '1';
					State 	<= S0;
				WHEN S8 =>
					PCWriteCond	<= '1';
					PCSource(0)	<= '1';
					ALUSrcA		<= '1';
					State 		<= S0;
				WHEN S9 =>
					PCWrite		<= '1';
					PCSource(1)	<= '1';
					ALUOp(0)		<= '1';
					State 		<= S0;
				WHEN OTHERS	=>
					State	<= S0;
			END CASE;
		END IF;
	END PROCESS;
END behavior;