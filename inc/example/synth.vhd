library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity UART_TX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic_vector (7 downto 0);
    DIN_VLD: in std_logic;
    DIN_RDY: out std_logic;
    DOUT: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic);
end entity uart_tx_fsm;

architecture rtl of uart_tx_fsm is
begin
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_tx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  subtype typwrap_DIN is std_logic_vector (7 downto 0);
  signal wrap_DIN: typwrap_DIN;
  signal wrap_DIN_VLD: std_logic;
  signal wrap_DIN_RDY: std_logic;
  signal wrap_DOUT: std_logic;
  constant n2_o : std_logic := '1';
  constant n3_o : std_logic := '1';
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  wrap_din_vld <= din_vld;
  din_rdy <= wrap_din_rdy;
  dout <= wrap_dout;
  wrap_DIN_RDY <= n2_o;
  wrap_DOUT <= n3_o;
  -- uart_tx.vhd:29:5
  fsm : entity work.uart_tx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST);
end rtl;
