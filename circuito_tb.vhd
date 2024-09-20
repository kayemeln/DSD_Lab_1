--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   14:31:45 09/10/2014
-- Design Name:
-- Module Name:   C:/xup/vhdl/introLab/tb_circuito.vhd
-- Project Name:  introLab
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: circuito
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
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity circuito_tb is
end circuito_tb;

architecture behavior of circuito_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component circuito
    port(
      clk     : in  std_logic;
      rst     : in  std_logic;
      exec    : in  std_logic;
      instr   : in  std_logic_vector(2 downto 0);
      data_in : in  std_logic_vector(9 downto 0);
      res     : out std_logic_vector(15 downto 0)
    );
  end component;


  --Inputs
  signal clk     : std_logic                    := '0';
  signal rst     : std_logic                    := '0';
  signal exec    : std_logic                    := '0';
  signal instr   : std_logic_vector(2 downto 0) := (others => '0');
  signal data_in : std_logic_vector(9 downto 0) := (others => '0');

  --Outputs
  signal res  : std_logic_vector(15 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : circuito port map (
    clk     => clk,
    rst     => rst,
    exec    => exec,
    instr   => instr,
    data_in => data_in,
    res     => res
  );

  -- Clock definition
  clk <= not clk after clk_period/2;

  -- Stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    wait for 100 ns;

    wait for clk_period*10;

    -- insert stimulus here
    -- note that input signals should never change at the positive edge of the clock
    rst <= '1' after 20 ns,
           '0' after 40 ns;

    data_in <= "1010110010" after 40 ns,
               "1100101011" after 100 ns,
               "0110111001" after 360 ns;

    instr <= "101" after 40 ns,          -- load1
             "110" after 120 ns,         -- load2
             "000" after 200 ns,         -- add
             "001" after 280 ns,         -- sub
             "010" after 360 ns,         -- mul
             "011" after 440 ns,         -- logic
             "100" after 520 ns;         -- shift

    exec <= '1' after 40 ns,
            '0' after 80 ns,
            '1' after 120 ns,
            '0' after 160 ns,
            '1' after 200 ns,
            '0' after 240 ns,
            '1' after 280 ns,
            '0' after 320 ns,
            '1' after 360 ns,
            '0' after 400 ns,
            '1' after 440 ns,
            '0' after 480 ns,
            '1' after 520 ns,
            '0' after 560 ns;
    wait;
  end process;

end;
