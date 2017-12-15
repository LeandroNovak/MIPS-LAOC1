LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS 
	PORT(
		SIGNAL ALUOut				: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL Next_Inst			: IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		SIGNAL Zero					: IN  STD_LOGIC;
		SIGNAL PC_out				: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		SIGNAL PCSource			: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL PCWriteCond		: IN	STD_LOGIC;
		SIGNAL PCWrite 			: IN 	STD_LOGIC;
		SIGNAL IRWrite				: IN 	STD_LOGIC;
		SIGNAL clock,reset		: IN  STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC				      : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL Next_PC, Mem_Addr 	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Jump_address			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Inst						: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_cond					: STD_LOGIC;
BEGIN
	PC_cond <= (Zero and PCWriteCond) or PCWrite; 
	PC(1 DOWNTO 0) <= "00";
	PC_out <= PC;
	Mem_Addr <= Next_PC;
	
	Jump_address(7 DOWNTO 0) <= Next_Inst(7 DOWNTO 0);
	
	PROCESS
	BEGIN
		IF (PC_cond = '1') THEN
			IF (Reset = '1') THEN
				Next_PC <= X"00";
			ELSIF ((PCSource = "00") OR (PCSource = "01")) THEN
				Next_PC <= ALUOut;
			ELSIF (PCSource = "10") THEN
				Next_PC <= Jump_address;
			END IF;
		END IF;
	
		WAIT UNTIL(clock'EVENT) AND (clock = '1');
		IF reset = '1' THEN
			PC(9 DOWNTO 2) <= "00000000";
		ELSE
			IF IRWrite = '1' THEN
				PC(9 DOWNTO 2) <= Next_PC;
			END IF;
		END IF;
	END PROCESS;
END behavior;
