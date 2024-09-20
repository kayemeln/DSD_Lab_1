library IEEE;
use IEEE.STD_LOGIC_1164.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
	clk, rst, exec	: in  std_logic;
	instr         	: in  std_logic_vector (2 downto 0);
	-----------------------------------------------------
	enables       	: out std_logic_vector (1 downto 0);
	selectors     	: out std_logic_vector (1 downto 0);
	alu_selector	: out std_logic_vector (2 downto 0));
end control;

architecture Behavioral of control is
	type fsm_states is (s_initial, s_end, s_sub, s_add, s_mul, s_logic, s_shift, s_load_1, s_load_2);
	signal currstate, nextstate : fsm_states;

begin
	state_reg : process (clk)
	begin
		if clk'event and clk = '1' then
			if rst = '1' then
				currstate <= s_initial;
			else
				currstate <= nextstate;
			end if;
		end if;
	end process;

	state_comb : process (currstate, instr, exec)
	begin  --  process

		nextstate <= currstate;  -- by default, does not change the state.
		selectors		<= "00";
		enables			<= "00";
		alu_selector	<= "000";

		case currstate is
			when s_initial =>
				if exec = '1' then
					if instr = "000" then
						nextstate <= s_add;
					elsif instr = "001" then
						nextstate <= s_sub;
					elsif instr = "010" then
						nextstate <= s_mul;
					elsif instr = "011" then
						nextstate <= s_logic;
					elsif instr = "100" then
						nextstate <= s_shift;
					elsif instr = "101" then
						nextstate <= s_load_1;
					elsif instr = "110" then
						nextstate <= s_load_2;
					end if;
				end if;
				selectors		<= "00";
				enables			<= "00";
				alu_selector	<= "000";

			when s_add =>
				nextstate		<= s_end;
				selectors		<= "11";
				enables			<= "01";
				alu_selector	<= "001";

			when s_sub =>
				nextstate		<= s_end;
				selectors		<= "11";
				enables			<= "01";
				alu_selector	<= "010";

			when s_mul =>
				nextstate		<= s_end;
				selectors		<= "11";
				enables			<= "01";
				alu_selector	<= "011";
			
			when s_logic =>
				nextstate		<= s_end;
				selectors		<= "11";
				enables			<= "01";
				alu_selector	<= "100";
				
			when s_shift =>
				nextstate		<= s_end;
				selectors		<= "11";
				enables			<= "01";
				alu_selector	<= "101";
			
			when s_load_1 =>
				nextstate		<= s_end;
				selectors		<= "00";
				enables			<= "10";
				alu_selector	<= "000";
				
			when s_load_2 =>
				nextstate		<= s_end;
				selectors		<= "10";
				enables			<= "01";
				alu_selector	<= "000";

			when s_end =>
				if exec = '0' then
					nextstate	<= s_initial;
				end if;
				selectors		<= "00";
				enables			<= "00";
				alu_selector	<= "000";
		end case;
	end process;

end Behavioral;

