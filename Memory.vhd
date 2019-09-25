----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:45:14 07/17/2019 
-- Design Name: 
-- Module Name:    Memory - Behavioral 
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

entity Memory is
    Port ( Clk : in STD_LOGIC;
			  Adr : in  STD_LOGIC_VECTOR (31 downto 0);
           Wd : in  STD_LOGIC_VECTOR (31 downto 0);
           We : in  STD_LOGIC;
           Rd : out  STD_LOGIC_VECTOR (31 downto 0));
end Memory;

architecture Behavioral of Memory is

-- Instructions
-- R-type : |000000|00000|00000|00000|00000|000000|
--				 op(6)  rs(5) rt(5) rd(5) sh(5) fn(6)
-- I-type : |000000|00000|00000|0000000000000000|
--				 op(6)  rs(5) rt(5)   address(16) 
-- J-type : |000000|00000000000000000000000000|
--				 op(6)  			address(26)


--type ram_type is array(0 to 127) of STD_LOGIC_VECTOR (7 downto 0);
--signal ram : ram_type := (
--		X"20", X"02", X"00", X"05",	--   0(X"00")		main		addi $2, $0, 5		$2 = 5
--		X"20", X"03", X"00", X"0C", 	--   4(X"04")					addi $3, $0, 12	$3 = 12
--		X"20", X"67", X"FF", X"F7",	--   8(X"08")					addi $7, $3, -9	$7 = 12 - 9 = 3
--		X"00", X"E2", X"20", X"25",	--  12(X"0C")					or	  $4, $7, $2	$4 = 3 OR 5 = 7
--		X"00", X"64", X"28", X"24",	--  16(X"10")					and  $5, $3, $4  	$5 = 12 AND 7 = 4
--		X"00", X"A4", X"28", X"20",	--  20(X"14")					add  $5, $5, $4  	$5 = 4 + 7 = 11
--		X"10", X"A7", X"00", X"0A",	--  24(X"18")					beq  $5, $7, end
--		X"00", X"64", X"20", X"2A",	--  28(X"1C")					slt  $4, $3, $4	$4 = (12 < 7) = 0
--		X"10", X"80", X"00", X"01",	--  32(X"20")					beq  $4, $0, around
--		X"20", X"05", X"00", X"00",	--  36(X"24") X				addi $5, $0, 0
--		X"00", X"E2", X"20", X"2A",	--  40(X"28")		around	slt  $4, $7, $2   $4 = (3 < 5) = 1 
--		X"00", X"85", X"38", X"20",	--  44(X"2C")					add  $7, $4, $5   $7 = 1 + 11 = 12
--		X"00", X"E2", X"38", X"22", 	--  48(X"30")					sub  $7, $7, $2   $7 = 12 − 5 = 7
--		X"AC", X"67", X"00", X"44",	--  52(X"34")					sw   $7, 68($3)   mem[80] = 7
--		X"8C", X"02", X"00", X"50",	--  56(X"38")					lw   $2, 80($0) 	$2 = mem[80] = 7
--		X"08", X"00", X"00", X"11", 	--  60(X"3C")					j 	  end
--		X"20", X"02", X"00", X"01",	--  64(X"40") X				addi $2, $0, 1
--		X"AC", X"02", X"00", X"54",	--  68(X"44")		end 		sw   $2, 84($0)   mem[84] = 7
--		X"00", X"00", X"00", X"00",	--  72(X"48")
--		X"00", X"00", X"00", X"00",	--  76(X"4C")
--		X"00", X"00", X"00", X"00",	--  80(X"50")
--		X"00", X"00", X"00", X"00",	--  84(X"54")
--		X"00", X"00", X"00", X"00",	--  88(X"58")
--		X"00", X"00", X"00", X"00",	--  92(X"5C")
--		X"00", X"00", X"00", X"00",	--  96(X"60")
--		X"00", X"00", X"00", X"00",	--  100(X"64")
--		X"00", X"00", X"00", X"00",	--  104(X"68")
--		X"00", X"00", X"00", X"00",	--  108(X"6C")
--		X"00", X"00", X"00", X"00",	--  112(X"70")
--		X"00", X"00", X"00", X"00",	--  116(X"74")
--		X"00", X"00", X"00", X"00",	--  120(X"78")
--		X"00", X"00", X"00", X"00");	--  124(X"7C")

type ram_type is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
signal ram : ram_type := (
		X"20020005",	--   0(X"00")		main		addi $2, $0, 5		$2 = 5
		X"2003000C", 	--   4(X"04")					addi $3, $0, 12	$3 = 12
		X"2067FFF7",	--   8(X"08")					addi $7, $3, -9	$7 = 12 - 9 = 3
		X"00E22025",	--  12(X"0C")					or	  $4, $7, $2	$4 = 3 OR 5 = 7
		X"00642824",	--  16(X"10")					and  $5, $3, $4  	$5 = 12 AND 7 = 4		
		X"00A42820",	--  20(X"14")					add  $5, $5, $4  	$5 = 4 + 7 = 11
		X"10A7000A",	--  24(X"18")					beq  $5, $7, end
		X"0064202A",	--  28(X"1C")					slt  $4, $3, $4	$4 = (12 < 7) = 0
		X"10800001",	--  32(X"20")					beq  $4, $0, around
		X"20050000",	--  36(X"24") X				addi $5, $0, 0
		X"00E2202A",	--  40(X"28")		around	slt  $4, $7, $2   $4 = (3 < 5) = 1 
		X"00853820",	--  44(X"2C")					add  $7, $4, $5   $7 = 1 + 11 = 12
		X"00E23822", 	--  48(X"30")					sub  $7, $7, $2   $7 = 12 − 5 = 7
		X"AC670044",	--  52(X"34")					sw   $7, 68($3)   mem[80] = 7
		X"8C020050",	--  56(X"38")					lw   $2, 80($0) 	$2 = mem[80] = 7
		X"08000011",	--  60(X"3C")					j 	  end
		X"20020001",	--  64(X"40") X				addi $2, $0, 1
		X"AC020054",	--  68(X"44")		end 		sw   $2, 84($0)   mem[84] = 7
		X"00000000",	--  72(X"48")
		X"00000000",	--  76(X"4C")
		X"00000000",	--  80(X"50")
		X"00000000",	--  84(X"54")
		X"00000000",	--  88(X"58")
		X"00000000",	--  92(X"5C")
		X"00000000",	--  96(X"60")
		X"00000000",	--  100(X"64")
		X"00000000",	--  104(X"68")
		X"00000000",	--  108(X"6C")
		X"00000000",	--  112(X"70")
		X"00000000",	--  116(X"74")
		X"00000000",	--  120(X"78")
		X"00000000");	--  124(X"7C")
		
signal A : STD_LOGIC_VECTOR(31 downto 0);

begin
  
  A <= "00" & Adr(31 downto 2); -- devide by 4, because PC increases by 4
  
  Rd <= ram(CONV_INTEGER(A));

  process(Clk)
  begin
    if (Clk'event and Clk='1') then
      if (We='1') then
			
			ram(CONV_INTEGER(A)) <= Wd;
			
      end if;
    end if;
  end process;

end Behavioral;

