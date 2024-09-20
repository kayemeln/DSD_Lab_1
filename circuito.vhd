library IEEE;
use IEEE.STD_LOGIC_1164.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
  port (
	-- rst - center buttom
    clk, rst, exec	: in  std_logic;
    instr			: in  std_logic_vector(2 downto 0);
    data_in 		: in  std_logic_vector(9 downto 0);
	--------------------------------------------------
    res				: out std_logic_vector(15 downto 0)
    );
end circuito;

architecture Behavioral of circuito is
  component control
    port(
      clk, rst, exec	: in  std_logic;
      instr         	: in  std_logic_vector (2 downto 0);
	  -----------------------------------------------------
      enables       	: out std_logic_vector (1 downto 0);
      selectors     	: out std_logic_vector (1 downto 0);
	  alu_selector		: out std_logic_vector (2 downto 0)
      );
  end component;
  component datapath
    port(
      data_in				: in  std_logic_vector (9 downto 0);
      aluS					: in  std_logic_vector (2 downto 0);
	  mux1S, mux2S			: in  std_logic;
      r1E, r2E				: in  std_logic;
      clk, rst				: in  std_logic;
	  -----------------------------------------------------
      res					: out std_logic_vector (15 downto 0)
      );
  end component;
  signal enables 	: std_logic_vector(1 downto 0);
  signal sels    	: std_logic_vector(1 downto 0);
  signal aluS		: std_logic_vector(2 downto 0);


begin
  inst_control : control port map(
    clk       		=> clk,
    rst       		=> rst,
    exec      		=> exec,
    instr     		=> instr,
    enables   		=> enables,
    selectors 		=> sels,
	  alu_selector => aluS
  );

  inst_datapath : datapath port map(
      data_in	=> data_in,
      rst		=> rst,
      r1E		=> enables(1),
      r2E		=> enables(0),
      mux1S	=> sels(0),
      mux2S	=> sels(1),
      aluS	=> aluS,
      clk		=> clk,
      res		=> res
  );
end Behavioral;