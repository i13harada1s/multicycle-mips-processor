----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:43 07/20/2019 
-- Design Name: 
-- Module Name:    MainDecoder - Behavioral 
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

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainDecoder is
	Port ( Clk : in STD_LOGIC;
			 Reset : in STD_LOGIC;
		    Opcode : in  STD_LOGIC_VECTOR(5 downto 0);
		    MemtoReg : out  STD_LOGIC;
		    RegDst : out  STD_LOGIC;
		    IorD : out  STD_LOGIC;
		    PCSrc : out  STD_LOGIC_VECTOR(1 downto 0);
		    ALUSrcB : out  STD_LOGIC_VECTOR(1 downto 0);
		    ALUSrcA : out  STD_LOGIC;
		    IRWrite : out  STD_LOGIC;
		    MemWrite : out  STD_LOGIC;
		    PCWrite : out  STD_LOGIC;
		    Branch : out  STD_LOGIC;
		    RegWrite : out  STD_LOGIC;
		    ALUOp : out  STD_LOGIC_VECTOR(1 downto 0));
end MainDecoder;

architecture Behavioral of MainDecoder is

signal State	: STD_LOGIC_VECTOR(3 downto 0);
signal NextState	: STD_LOGIC_VECTOR(3 downto 0);

begin

	-- Opcode  Instruction
	----------------------
	-- 000000  R-type
	-- 100011  lw
	-- 101011  sw
	-- 000100  beq
	-- 001000  addi
	-- 000010  j
	
	NextState <= "0000" when (State="0100") or
									 (State="0101") or
									 (State="0111") or
									 (State="1000") or
									 (State="1010") or
									 (State="1011") else --Fetch
					 "0001" when (State="0000") else --Decode
					 "0010" when ((State="0001") and (Opcode="100011" or 
																 Opcode="101011")) else --MemAdr
					 "0011" when ((State="0010") and (Opcode="100011")) else --MemRead
					 "0100" when (State="0011") else --MemWriteback
					 "0101" when (State="0010") and (Opcode="101011") else --MemWrite
					 "0110" when (State="0001") and (Opcode="000000") else --Execute
					 "0111" when (State="0110") else --ALUWriteback
					 "1000" when (State="0001") and (Opcode="000100") else --Branch
					 "1001" when (State="0001") and (Opcode="001000") else --ADDIExecute
					 "1010" when (State="1001") else --ADDIWriteback
					 "1011" when (State="0001") and (Opcode="000010") else --Jump
					 "----";

	MemtoReg <= '1' when (State="0100") else
					'0';
					
	RegDst <= '1' when (State="0111") else
				 '0';
	
	IorD <= '1' when (State="0011") or
						  (State="0101") else
			  '0';
	
	PCSrc <= "10" when (State="1011") else
				"01" when (State="1000") else
				"00";
   
	ALUSrcB <= "11" when (State="0001") else
				  "10" when (State="0010") or
                        (State="1001") else
				  "01" when (State="0000") else
				  "00";
   
	ALUSrcA <= '1' when (State="0010") or
							  (State="0110") or
							  (State="1000") or
							  (State="1001") else
				  '0';
	
   IRWrite <= '1' when (State="0000") else
				  '0';
	
   MemWrite <= '1' when (State="0101") else
					'0';
	
   PCWrite <= '1' when (State="0000") or
							  (State="1011") else
				  '0';
	
   Branch <= '1' when (State="1000") else
	          '0';
	
   RegWrite <= '1' when (State="0100") or
								(State="0111") or
								(State="1010") else
					'0';
	
   ALUOp <= "10" when (State="0110") else
	         "01" when (State="1000") else
				"00";
				
	process(Clk, Reset)
	begin
		if (Reset='1') then
			State <= "0000";
		elsif (Clk'event and Clk='1') then
			State <= NextState;
		end if;
	end process;

end Behavioral;

