----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:44:34 07/17/2019 
-- Design Name: 
-- Module Name:    RegFile - Behavioral 
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

entity RegFile is
    Port ( Clk : in STD_LOGIC;
			  Reset : in STD_LOGIC;
			  Ra1 : in  STD_LOGIC_VECTOR(4 downto 0);
           Ra2 : in  STD_LOGIC_VECTOR(4 downto 0);
           Wa3 : in  STD_LOGIC_VECTOR(4 downto 0);
           Wd3 : in  STD_LOGIC_VECTOR(31 downto 0);
           We3 : in  STD_LOGIC;
           Rd1 : out  STD_LOGIC_VECTOR(31 downto 0);
           Rd2 : out  STD_LOGIC_VECTOR(31 downto 0));
end RegFile;

architecture Behavioral of RegFile is

type ram_type is array(31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal reg : ram_type;

begin
	process(Clk, Reset) 
	begin
		if (Reset='1') then
			reg(31 downto 0) <= (others => X"00000000");
		elsif (Clk'event and Clk='1') then
			if (We3='1') then
				reg(CONV_INTEGER(Wa3)) <= Wd3;
			end if;
		end if;
	end process;
	
	Rd1 <= X"00000000" when (CONV_INTEGER(Ra1)=0) else
			 reg(CONV_INTEGER(Ra1));
			 
	Rd2 <= X"00000000" when (CONV_INTEGER(Ra2)=0) else
			 reg(CONV_INTEGER(Ra2));	

end Behavioral;

