----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 09/13/2016 07:01:44 PM
-- Design Name:
-- Module Name: fpga_basicIO - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_basicIO is
  port (
    clk : in  std_logic;  -- 100MHz clock
    btnC, btnU, btnL, btnR, btnD : in  std_logic;  -- buttons
    sw  : in  std_logic_vector(15 downto 0);  -- switches
    led : out std_logic_vector(15 downto 0);  -- leds
    an  : out std_logic_vector(3 downto 0);  -- display selectors
    seg : out std_logic_vector(6 downto 0);  -- display 7-segments
    dp  : out std_logic   -- display point
    );
end fpga_basicIO;

architecture Behavioral of fpga_basicIO is
  -- signal dd3, dd2, dd1, dd0 : std_logic_vector(6 downto 0);
  signal res           : std_logic_vector(15 downto 0);
  signal dact          : std_logic_vector(3 downto 0);
  -- signal btnRinstr : std_logic_vector(3 downto 0);
  -- signal clk10hz, clk_disp : std_logic;
  signal btn, btnDeBnc : std_logic_vector(4 downto 0);
  -- registered input buttons
  signal btnCreg, btnUreg, btnLreg, btnRreg, btnDreg : std_logic;
  -- registered input switches
  signal sw_reg : std_logic_vector(15 downto 0);

  component disp7
    port (
      digit3, digit2, digit1, digit0 : in  std_logic_vector(3 downto 0);
      dp3, dp2, dp1, dp0             : in  std_logic;
      clk                            : in  std_logic;
      dactive                        : in  std_logic_vector(3 downto 0);
      en_disp_l                      : out std_logic_vector(3 downto 0);
      segm_l                         : out std_logic_vector(6 downto 0);
      dp_l                           : out std_logic);
  end component;

  component debouncer
    generic (
      DEBNC_CLOCKS : integer;
      PORT_WIDTH   : integer);
    port (
      signal_i : in  std_logic_vector(4 downto 0);
      clk_i    : in  std_logic;
      signal_o : out std_logic_vector(4 downto 0));
  end component;

  component circuito
    port(
      clk     : in  std_logic;
      rst     : in  std_logic;
      exec    : in  std_logic;
      mux2S   : in std_logic;
      instr   : in  std_logic_vector(2 downto 0);
      data_in : in  std_logic_vector(9 downto 0);
      ov      : out std_logic;
      res     : out std_logic_vector(15 downto 0)
      );
  end component;

  signal ov, exec: std_logic;
  signal instr: std_logic_vector(2 downto 0);

begin
  led <= sw_reg(15 downto 11) & ov & sw_reg(9 downto 0);

  dact <= "1111";

  inst_disp7 : disp7 port map(
    digit3    => res(15 downto 12),
    digit2    => res(11 downto 8),
    digit1    => res(7 downto 4),
    digit0    => res(3 downto 0),
    dp3       => btnLreg, dp2 => btnDreg, dp1 => btnRreg, dp0 => btnUreg,
    clk       => clk,
    dactive   => dact,
    en_disp_l => an,
    segm_l    => seg,
    dp_l      => dp);

  inst_circuito : circuito port map(
    clk     => clk,
    rst     => btnCreg,
    exec    => exec,
    instr   => instr,
    mux2S   => sw_reg(14),
    data_in => sw_reg(9 downto 0),
    ov   => ov,
    res => res);

  exec <= btnUreg or btnRreg or btnDreg or btnLreg;
  instr(0) <= sw_reg(15);
  instr(2 downto 1) <= "00" when btnUreg = '1' else
                       "01" when btnRreg = '1' else
                       "10" when btnDreg = '1' else 
                       "11" when btnLreg = '1' else
                       "00";

  -- Debounces btn signals
  btn <= btnC & btnU & btnL & btnR & btnD;
  Inst_btn_debounce : debouncer
    generic map (
      DEBNC_CLOCKS => (2**20),
      PORT_WIDTH   => 5)
    port map (
      signal_i => btn,
      clk_i    => clk,
      signal_o => btnDeBnc);

  process (clk)
  begin
    if rising_edge(clk) then
      btnCreg <= btnDeBnc(4);
      btnUreg <= btnDeBnc(3);
      btnLreg <= btnDeBnc(2);
      btnRreg <= btnDeBnc(1);
      btnDreg <= btnDeBnc(0);
      sw_reg  <= sw;
    end if;
  end process;

end Behavioral;
