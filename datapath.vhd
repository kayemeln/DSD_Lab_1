library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity datapath is
	port (
		data_in				: in  std_logic_vector (9 downto 0);
		aluS 				: in  std_logic_vector (2 downto 0)
		mux1S, mux2S		: in  std_logic;
		r1E, r2E			: in  std_logic;
		clk, rst			: in  std_logic;
		-----------------------------------------------------
		res					: out std_logic_vector (15 downto 0));
end datapath;

architecture behavioral of datapath is
	signal data_in_two_c, res_mux1, res_add, res_sub, res_mul, res_logic, res_shift, res_alu, res_mux2 : std_logic_vector(15 downto 0);

	signal r1_sg	: signed (9 downto 0);
	signal res_add_sg, res_sub_sg, res_mul_sg, r2_sg: signed (15 downto 0);

	-- the next signals initialization is only considered for simulation
	signal register1 : std_logic_vector (9 downto 0) := (others => '0');
	signal register2 : std_logic_vector (15 downto 0) := (others => '0');

begin
	-- adder/subtracter/multiplier
	r1_sg      	<= signed(register1);
	r2_sg      	<= signed(register2);
	res_add		<= std_logic_vector(res_add_sg);
	res_sub		<= std_logic_vector(res_sub_sg);
	res_mul		<= std_logic_vector(res_mul_sg);
	res_add_sg 	<= r1_sg + r2_sg;
	res_sub_sg 	<= r1_sg - r2_sg;
	res_mul_sg 	<= r1_sg * r2_sg;
	
	-- logic unit
	res_logic <= ("000000" & register1) nor register2;
	
	-- shift unit
	res_shift <= "00000" & register1 & '0';
	
	-- multiplexer 1
	res_mux1 <= data_in_two_c when mux1S = '0'
			   else res_alu;
	
	-- multiplexer 2
	res_mux2 <= "000000" & register1 when mux2S = '0'
			   else register2;

	-- alu output
	res_alu <= res_add when aluS = "001" else
						 res_sub when aluS = "010" else
						 res_mul when aluS = "011" else
						 res_logic when aluS = "100" else
						 res_shift when aluS = "101" else
						 register2;

	-- convert sign-magnitude to two-complement
	data_in_two_c <= "000000" & data_in when data_in(9) = '0' else
									 "111111" & ((not data_in) + 1);
	-- register R1
	process (clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				register1 <= "0000000000";
			elsif r1E = '1' then
				register1 <= data_in_two_c(9 downto 0);
			end if;
		end if;
	end process;

	-- register R2
	process (clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				register2 <= X"0000";
			elsif r2E = '1' then
				register2 <= res_mux1;
			end if;
		end if;
	end process;

	-- output
	res  <= res_mux2;
end behavioral;