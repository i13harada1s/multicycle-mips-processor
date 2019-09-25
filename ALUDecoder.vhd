----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:49:30 07/17/2019 
-- Design Name: 
-- Module Name:    ALUDecoder - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALUDecoder is
    Port ( Funct : in  STD_LOGIC_VECTOR(5 downto 0);
           ALUOp : in  STD_LOGIC_VECTOR(1 downto 0);
           ALUControl : out  STD_LOGIC_VECTOR(2 downto 0));
end ALUDecoder;

architecture Behavioral of ALUDecoder is

begin

	-- ALUOp  Funct   ALUControl  Meaning
	--------------------------------------
	-- 00		 X       010         add
	-- 01     X       110         subtract
	-- 1X	    100000  010         add
	-- 1X     100010  110			subtract
	-- 1X     100100  000			and
	-- 1X     100101  001			or
	-- 1X     101010  111			slt


	ALUControl <= "010" when ALUOp="00" else 		-- add
					  "110" when ALUOp="01" else 		-- sub
					  -- R-type instructions
					  "010" when Funct="100000" else -- add
					  "110" when Funct="100010" else -- sub
					  "000" when Funct="100100" else -- and
 					  "001" when Funct="100101" else -- or
					  "111" when Funct="101010" else -- slt
					  "---";									-- ???

end Behavioral;

