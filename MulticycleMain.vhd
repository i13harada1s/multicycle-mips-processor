----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:51:08 07/19/2019 
-- Design Name: 
-- Module Name:    MulticycleMain - Behavioral 
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

entity MulticycleMain is
	Port ( Clk : in STD_LOGIC;
			 Reset : in STD_LOGIC;
			 -- Outputs of Registers
			 Out_PC : out STD_LOGIC_VECTOR(31 downto 0);
			 Out_Instr : out STD_LOGIC_VECTOR(31 downto 0);
			 Out_Data : out STD_LOGIC_VECTOR(31 downto 0);
			 Out_A : out STD_LOGIC_VECTOR(31 downto 0);
			 Out_B : out STD_LOGIC_VECTOR(31 downto 0);
			 Out_ALU : out STD_LOGIC_VECTOR(31 downto 0));
			 
end MulticycleMain;

architecture Behavioral of MulticycleMain is

-- Register
signal PC : STD_LOGIC_VECTOR(31 downto 0);
signal Instr : STD_LOGIC_VECTOR(31 downto 0);
signal Data : STD_LOGIC_VECTOR(31 downto 0);
signal A : STD_LOGIC_VECTOR(31 downto 0);
signal B : STD_LOGIC_VECTOR(31 downto 0);
signal ALUOut : STD_LOGIC_VECTOR(31 downto 0);

-- ControlPath
signal PCEn : STD_LOGIC;
signal IorD : STD_LOGIC;
signal MemWrite : STD_LOGIC;
signal IRWrite : STD_LOGIC;
signal RegDst : STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal ALUSrcA : STD_LOGIC;
signal ALUSrcB : STD_LOGIC_VECTOR(1 downto 0);
signal ALUControl : STD_LOGIC_VECTOR(2 downto 0);
signal PCSrc : STD_LOGIC_VECTOR(1 downto 0);
signal PCWrite : STD_LOGIC;
signal Branch : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0); -- ControlPath in MainDecoder

-- DataPath
signal PC_Dash : STD_LOGIC_VECTOR(31 downto 0);
signal Adr : STD_LOGIC_VECTOR(31 downto 0);
signal RD : STD_LOGIC_VECTOR(31 downto 0);
signal WA3 : STD_LOGIC_VECTOR(4 downto 0);
signal RD1 : STD_LOGIC_VECTOR(31 downto 0);
signal RD2 : STD_LOGIC_VECTOR(31 downto 0);
signal WD3 : STD_LOGIC_VECTOR(31 downto 0);
signal SrcA : STD_LOGIC_VECTOR(31 downto 0);
signal SrcB : STD_LOGIC_VECTOR(31 downto 0);
signal Signlmm : STD_LOGIC_VECTOR(31 downto 0);
signal Sign : STD_LOGIC;
signal Zero : STD_LOGIC;
signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);


COMPONENT SignExtend
	PORT(
		X: IN std_logic_vector(15 downto 0);          
		Y : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT ALU
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		F : IN std_logic_vector(2 downto 0);          
		C : OUT std_logic;
		Z : OUT std_logic;
		Y : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT Memory
	PORT(
		Clk : IN std_logic;
		Adr : IN std_logic_vector(31 downto 0);
		Wd : IN std_logic_vector(31 downto 0);
		We : IN std_logic;          
		Rd : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT RegFile
	PORT(
		Clk : IN std_logic;
		Reset : IN std_logic;
		Ra1 : IN std_logic_vector(4 downto 0);
		Ra2 : IN std_logic_vector(4 downto 0);
		Wa3 : IN std_logic_vector(4 downto 0);
		Wd3 : IN std_logic_vector(31 downto 0);
		We3 : IN std_logic;          
		Rd1 : OUT std_logic_vector(31 downto 0);
		Rd2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
COMPONENT MainDecoder
	PORT(
		Clk : IN std_logic;
		Reset : IN std_logic;
		Opcode : IN std_logic_vector(5 downto 0);          
		MemtoReg : OUT std_logic;
		RegDst : OUT std_logic;
		IorD : OUT std_logic;
		PCSrc : OUT std_logic_vector(1 downto 0);
		ALUSrcB : OUT std_logic_vector(1 downto 0);
		ALUSrcA : OUT std_logic;
		IRWrite : OUT std_logic;
		MemWrite : OUT std_logic;
		PCWrite : OUT std_logic;
		Branch : OUT std_logic;
		RegWrite : OUT std_logic;
		ALUOp : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
COMPONENT ALUDecoder
	PORT(
		Funct : IN std_logic_vector(5 downto 0);
		ALUOp : IN std_logic_vector(1 downto 0);          
		ALUControl : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;


begin

	Inst_SignExtend: SignExtend PORT MAP(
		X => Instr(15 downto 0),
		Y => Signlmm
	);
	
	Inst_ALU: ALU PORT MAP(
		A => SrcA,
		B => SrcB,
		F => ALUControl,
		C => Sign,
		Z => Zero,
		Y => ALUResult
	);
	
	Inst_Memory: Memory PORT MAP(
		Clk => Clk,
		Adr => Adr,
		Wd => B,
		We => MemWrite,
		Rd => RD
	);
	
	Inst_RegFile: RegFile PORT MAP(
		Clk => Clk,
		Reset => Reset,
		Ra1 => Instr(25 downto 21),
		Ra2 => Instr(20 downto 16),
		Wa3 => WA3,
		Wd3 => WD3,
		We3 => RegWrite,
		Rd1 => RD1,
		Rd2 => RD2
	);
	
	Inst_MainDecoder: MainDecoder PORT MAP(
		Clk => Clk,
		Reset => Reset,
		Opcode => Instr(31 downto 26),
		MemtoReg => MemtoReg,
		RegDst => RegDst,
		IorD => IorD,
		PCSrc => PCSrc,
		ALUSrcB => ALUSrcB,
		ALUSrcA => ALUSrcA,
		IRWrite => IRWrite,
		MemWrite => MemWrite,
		PCWrite => PCWrite,
		Branch => Branch,
		RegWrite => RegWrite,
		ALUOp => ALUOp
	);
	
	Inst_ALUDecoder: ALUDecoder PORT MAP(
		Funct => Instr(5 downto 0),
		ALUOp => ALUOp,
		ALUControl => ALUControl
	);
	

-- Outputs
	Out_PC <= PC;
	Out_Instr <= Instr;
	Out_Data <= Data;
	Out_A <= A;
	Out_B <= B;
	Out_ALU <= ALUOut;


-- MultiPlexer
	PC_Dash <= ALUResult when (PCSrc="00") else
				  ALUOut when (PCSrc="01") else
				  PC(31 downto 28) & Instr(25 downto 0) & "00"; -- shift left by 2bits
	
	Adr <= PC when (IorD='0') else
			 ALUOut;
			 
	WA3 <= Instr(20 downto 16) when (RegDst='0') else
			 Instr(15 downto 11);
			  
   WD3 <= ALUOut when (MemtoReg='0') else
			 Data;
			  
	SrcA <= PC when (ALUSrcA='0') else
			  A;
	
	SrcB <= B when (ALUSrcB="00") else
			  X"00000004" when (ALUSrcB="01") else
			  Signlmm when (ALUSrcB="10") else
			  Signlmm(29 downto 0) & "00"; -- shift left by 2bits


-- PC Enable 
	PCEn <= PCWrite or (Branch and Zero);


-- Register
	-- PC
	process(Clk, Reset)
	begin
		if (Reset='1') then
			PC <= X"00000000";
		elsif (Clk'event and Clk='1') then
			if (PCEn='1') then
				PC <= PC_Dash;
			end if;
		end if;
	end process;
	
	-- Instr
	process(Clk, Reset)
	begin
		if (Reset='1') then
			Instr <= X"00000000";
		elsif (Clk'event and Clk='1') then
			if (IRWrite='1') then
				Instr <= RD;
			end if;
		end if;
	end process;
	
	-- Data
	process(Clk, Reset)
	begin
		if (Reset='1') then
			Data <= X"00000000";
		elsif (Clk'event and Clk='1') then
			Data <= RD;
		end if;
	end process;
	
	-- A
	process(Clk, Reset)
	begin
		if (Reset='1') then
			A <= X"00000000";
		elsif (Clk'event and Clk='1') then
			A <= RD1;
		end if;
	end process;
	
	-- B
	process(Clk, Reset)
	begin
		if (Reset='1') then
			B <= X"00000000";
		elsif (Clk'event and Clk='1') then
			B <= RD2;
		end if;
	end process;
	
	-- ALUOut
	process(Clk, Reset)
	begin
		if (Reset='1') then
			ALUOut <= X"00000000";
		elsif (Clk'event and Clk='1') then
			ALUOut <= ALUResult;
		end if;
	end process;
			  
end Behavioral;

