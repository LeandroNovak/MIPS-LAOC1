LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS 
	PORT(	
		SIGNAL Instruction		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		SIGNAL Pc_plus_4_out		: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		SIGNAL Add_result			: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL Branch				: IN 	STD_LOGIC;
		SIGNAL Zero					: IN  STD_LOGIC;
		SIGNAL PC_out				: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		SIGNAL clock,reset		: IN  STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4       : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL next_PC, Mem_Addr 	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode 			=> "ROM",
		width_a						=> 32,
		widthad_a 					=> 8,
		lpm_type 					=> "altsyncram",
		outdata_reg_a 				=> "UNREGISTERED",
		init_file 					=> "program.mif",
		intended_device_family 	=> "Cyclone")

	PORT MAP (
		clock0 		=> clock,
		address_a 	=> Mem_Addr,
		q_a 			=> Instruction);
		
	PC(1 DOWNTO 0) <= "00";
	
	PC_out <= PC;
	PC_plus_4_out <= PC_plus_4;
	
	Mem_Addr <= Next_PC;
	PC_plus_4(9 DOWNTO 2) <= PC(9 DOWNTO 2) + 1;
	PC_plus_4(1 DOWNTO 0) <= "00";
	
	Next_PC <= X"00" WHEN Reset = '1' 
		ELSE Add_result WHEN ((Branch = '1') AND (Zero = '1')) 
		ELSE PC_plus_4(9 DOWNTO 2) ;
	
	PROCESS
	BEGIN
		WAIT UNTIL(clock'EVENT) AND (clock = '1');
		IF reset = '1' THEN
			PC(9 DOWNTO 2) <= "00000000";
		ELSE
			PC(9 DOWNTO 2) <= next_PC;
		END IF;
	END PROCESS;
END behavior;
