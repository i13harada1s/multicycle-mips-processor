--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:05:06 07/25/2019
-- Design Name:   
-- Module Name:   /home/parallels/Processor/Test.vhd
-- Project Name:  Processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MulticycleMain
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
 
ENTITY Test IS
END Test;
 
ARCHITECTURE behavior OF Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MulticycleMain
    PORT(
         Clk : IN  std_logic;
         Reset : IN  std_logic;
         Out_PC : OUT  std_logic_vector(31 downto 0);
			Out_Instr : OUT  std_logic_vector(31 downto 0);
			Out_Data : OUT  std_logic_vector(31 downto 0);
			Out_A : OUT  std_logic_vector(31 downto 0);
			Out_B : OUT  std_logic_vector(31 downto 0);
			Out_ALU : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Reset : std_logic := '1';

 	--Outputs
   signal Out_PC : std_logic_vector(31 downto 0);
	signal Out_Instr : std_logic_vector(31 downto 0);
	signal Out_Data : std_logic_vector(31 downto 0);
	signal Out_A : std_logic_vector(31 downto 0);
	signal Out_B : std_logic_vector(31 downto 0);
	signal Out_ALU : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MulticycleMain PORT MAP (
          Clk => Clk,
          Reset => Reset,
          Out_PC => Out_PC,
			 Out_Instr => Out_Instr,
			 Out_Data => Out_Data,
			 Out_A => Out_A,
			 Out_B => Out_B,
			 Out_ALU => Out_ALU
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
      -- hold reset state for 50 ns.
      wait for 50 ns;
		
      -- insert stimulus here 
		Reset <= '0';  -- start
		
      wait;
   end process;

END;
