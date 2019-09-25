----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:46:19 07/17/2019 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR(31 downto 0);
           B : in  STD_LOGIC_VECTOR(31 downto 0);
           F : in  STD_LOGIC_VECTOR(2 downto 0);
           C : out  STD_LOGIC;
			  Z : out  STD_LOGIC; 
           Y : out  STD_LOGIC_VECTOR(31 downto 0));
end ALU;

architecture Behavioral of ALU is

signal BB	: STD_LOGIC_VECTOR(31 downto 0);
signal S		: STD_LOGIC_VECTOR(32 downto 0);
signal R		: STD_LOGIC_VECTOR(31 downto 0);

begin

	BB <= not B when (F(2)='1') else 	 -- NOT-B
			B;

	S <= ('0' & A) + ('0' & BB) when F(2)='0' else -- ADD
		  ('0' & A) + ('0' & (BB+1));			 		  -- SUB

	R <= X"0000000" & "000" & S(31) when F(1 downto 0)="11" else	-- SLT
		  S(31 downto 0) when F(1 downto 0)="10" else					-- ADD/SUB
		  A or BB when F(1 downto 0)="01" else  							-- OR
		  A and BB;																	-- AND
	
	C <= S(32); -- Carry
	
	Z <= '1' when (R=X"00000000") else '0'; -- Zero
	
	Y <= R;	-- Result

end Behavioral;

