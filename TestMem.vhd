--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:36:21 09/22/2019
-- Design Name:   
-- Module Name:   /home/parallels/Processor/TestMem.vhd
-- Project Name:  Processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Memory
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestMem IS
END TestMem;
 
ARCHITECTURE behavior OF TestMem IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Memory
    PORT(
         Clk : IN  std_logic;
         Adr : IN  std_logic_vector(31 downto 0);
         Wd : IN  std_logic_vector(31 downto 0);
         We : IN  std_logic;
         Rd : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Adr : std_logic_vector(31 downto 0) := (others => '0');
   signal Wd : std_logic_vector(31 downto 0) := (others => '0');
   signal We : std_logic := '0';

 	--Outputs
   signal Rd : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Memory PORT MAP (
          Clk => Clk,
          Adr => Adr,
          Wd => Wd,
          We => We,
          Rd => Rd
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      --wait for Clk_period*10;

      -- insert stimulus here 
		Adr <= X"00000000";
		wait for 20 ns;
		
		Adr <= X"00000004";
		wait for 20 ns;
	
		Adr <= X"00000008";
		wait for 20 ns;
		
		-- Writing
		Adr <= X"0000000C";
		Wd <= X"FFFF0000";
		We <= '1';
		wait for 20 ns;
		We <= '0';

      wait;
   end process;

END;
