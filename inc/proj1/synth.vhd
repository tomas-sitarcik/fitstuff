library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    din : in std_logic;
    dout : out std_logic_vector (1 downto 0);
    address_out : out std_logic_vector (2 downto 0);
    midbit : out std_logic;
    dout_vld : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal state : std_logic_vector (1 downto 0);
  signal address_fsm : std_logic_vector (2 downto 0);
  signal counter : std_logic_vector (31 downto 0);
  signal real_address : std_logic_vector (31 downto 0);
  signal n83_o : std_logic;
  signal n84_o : std_logic;
  signal n86_o : std_logic_vector (1 downto 0);
  signal n88_o : std_logic_vector (1 downto 0);
  signal n90_o : std_logic_vector (2 downto 0);
  signal n92_o : std_logic_vector (31 downto 0);
  signal n94_o : std_logic_vector (31 downto 0);
  signal n96_o : std_logic;
  signal n98_o : std_logic_vector (31 downto 0);
  signal n100_o : std_logic;
  signal n102_o : std_logic_vector (1 downto 0);
  signal n104_o : std_logic_vector (2 downto 0);
  signal n106_o : std_logic_vector (1 downto 0);
  signal n108_o : std_logic_vector (31 downto 0);
  signal n110_o : std_logic;
  signal n112_o : std_logic_vector (31 downto 0);
  signal n114_o : std_logic;
  signal n116_o : std_logic;
  signal n118_o : std_logic_vector (31 downto 0);
  signal n120_o : std_logic_vector (2 downto 0);
  signal n122_o : std_logic;
  signal n124_o : std_logic;
  signal n125_o : std_logic;
  signal n127_o : std_logic;
  signal n128_o : std_logic_vector (2 downto 0);
  signal n130_o : std_logic;
  signal n132_o : std_logic_vector (31 downto 0);
  signal n134_o : std_logic_vector (1 downto 0);
  signal n135_o : std_logic_vector (2 downto 0);
  signal n137_o : std_logic;
  signal n139_o : std_logic_vector (1 downto 0);
  signal n141_o : std_logic_vector (2 downto 0);
  signal n143_o : std_logic_vector (31 downto 0);
  signal n145_o : std_logic_vector (31 downto 0);
  signal n146_o : std_logic_vector (1 downto 0);
  signal n147_o : std_logic_vector (2 downto 0);
  signal n148_o : std_logic;
  signal n149_o : std_logic_vector (1 downto 0);
  signal n150_o : std_logic_vector (2 downto 0);
  signal n151_o : std_logic_vector (31 downto 0);
  signal n152_o : std_logic_vector (31 downto 0);
  signal n153_o : std_logic_vector (1 downto 0);
  signal n154_o : std_logic_vector (2 downto 0);
  signal n156_o : std_logic;
  signal n157_o : std_logic_vector (1 downto 0);
  signal n158_o : std_logic_vector (2 downto 0);
  signal n159_o : std_logic_vector (31 downto 0);
  signal n160_o : std_logic_vector (31 downto 0);
  signal n162_o : std_logic;
  signal n164_o : std_logic_vector (31 downto 0);
  signal n166_o : std_logic;
  signal n168_o : std_logic;
  signal n170_o : std_logic;
  signal n172_o : std_logic_vector (1 downto 0);
  signal n174_o : std_logic_vector (2 downto 0);
  signal n176_o : std_logic;
  signal n178_o : std_logic_vector (1 downto 0);
  signal n180_o : std_logic;
  signal n181_o : std_logic_vector (3 downto 0);
  signal n183_o : std_logic_vector (1 downto 0);
  signal n185_o : std_logic_vector (2 downto 0);
  signal n187_o : std_logic;
  signal n189_o : std_logic;
  signal n191_o : std_logic_vector (1 downto 0);
  signal n193_o : std_logic_vector (2 downto 0);
  signal n195_o : std_logic_vector (31 downto 0);
  signal n197_o : std_logic_vector (31 downto 0);
  signal n207_q : std_logic_vector (1 downto 0) := "00";
  signal n208_q : std_logic_vector (2 downto 0) := "000";
  signal n209_q : std_logic := '0';
  signal n210_q : std_logic := '0';
  signal n211_q : std_logic_vector (1 downto 0) := "00";
  signal n212_q : std_logic_vector (2 downto 0) := "000";
  signal n213_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n214_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
begin
  dout <= n207_q;
  address_out <= n208_q;
  midbit <= n209_q;
  dout_vld <= n210_q;
  -- uart_rx_fsm.vhd:25:12
  state <= n211_q; -- (isignal)
  -- uart_rx_fsm.vhd:26:12
  address_fsm <= n212_q; -- (isignal)
  -- uart_rx_fsm.vhd:27:21
  counter <= n213_q; -- (isignal)
  -- uart_rx_fsm.vhd:28:21
  real_address <= n214_q; -- (isignal)
  -- uart_rx_fsm.vhd:32:12
  n83_o <= '1' when rising_edge (clk) else '0';
  -- uart_rx_fsm.vhd:35:28
  n84_o <= not din;
  -- uart_rx_fsm.vhd:35:21
  n86_o <= n207_q when n84_o = '0' else "01";
  -- uart_rx_fsm.vhd:35:21
  n88_o <= state when n84_o = '0' else "01";
  -- uart_rx_fsm.vhd:35:21
  n90_o <= address_fsm when n84_o = '0' else "000";
  -- uart_rx_fsm.vhd:35:21
  n92_o <= counter when n84_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:35:21
  n94_o <= real_address when n84_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:34:17
  n96_o <= '1' when state = "00" else '0';
  -- uart_rx_fsm.vhd:44:40
  n98_o <= std_logic_vector (unsigned (counter) + unsigned'("00000000000000000000000000000001"));
  -- uart_rx_fsm.vhd:45:32
  n100_o <= '1' when n98_o = "00000000000000000000000000001111" else '0';
  -- uart_rx_fsm.vhd:45:21
  n102_o <= n207_q when n100_o = '0' else "10";
  -- uart_rx_fsm.vhd:45:21
  n104_o <= n208_q when n100_o = '0' else "000";
  -- uart_rx_fsm.vhd:45:21
  n106_o <= state when n100_o = '0' else "10";
  -- uart_rx_fsm.vhd:45:21
  n108_o <= n98_o when n100_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:43:17
  n110_o <= '1' when state = "01" else '0';
  -- uart_rx_fsm.vhd:54:40
  n112_o <= std_logic_vector (unsigned (counter) + unsigned'("00000000000000000000000000000001"));
  -- uart_rx_fsm.vhd:55:32
  n114_o <= '1' when n112_o = "00000000000000000000000000001000" else '0';
  -- uart_rx_fsm.vhd:57:35
  n116_o <= '1' when n112_o = "00000000000000000000000000001111" else '0';
  -- uart_rx_fsm.vhd:58:54
  n118_o <= std_logic_vector (unsigned (real_address) + unsigned'("00000000000000000000000000000001"));
  -- uart_rx_fsm.vhd:59:52
  n120_o <= std_logic_vector (unsigned (address_fsm) + unsigned'("001"));
  -- uart_rx_fsm.vhd:61:40
  n122_o <= '1' when real_address = "00000000000000000000000000001000" else '0';
  -- uart_rx_fsm.vhd:61:56
  n124_o <= '1' when n112_o = "00000000000000000000000000001001" else '0';
  -- uart_rx_fsm.vhd:61:44
  n125_o <= n122_o and n124_o;
  -- uart_rx_fsm.vhd:68:35
  n127_o <= '1' when n112_o = "00000000000000000000000000010000" else '0';
  -- uart_rx_fsm.vhd:68:21
  n128_o <= n208_q when n127_o = '0' else address_fsm;
  -- uart_rx_fsm.vhd:68:21
  n130_o <= '0' when n127_o = '0' else n209_q;
  -- uart_rx_fsm.vhd:68:21
  n132_o <= n112_o when n127_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:61:21
  n134_o <= n207_q when n125_o = '0' else "11";
  -- uart_rx_fsm.vhd:61:21
  n135_o <= n128_o when n125_o = '0' else n208_q;
  -- uart_rx_fsm.vhd:61:21
  n137_o <= n130_o when n125_o = '0' else '0';
  -- uart_rx_fsm.vhd:61:21
  n139_o <= state when n125_o = '0' else "11";
  -- uart_rx_fsm.vhd:61:21
  n141_o <= address_fsm when n125_o = '0' else "000";
  -- uart_rx_fsm.vhd:61:21
  n143_o <= n132_o when n125_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:61:21
  n145_o <= real_address when n125_o = '0' else "00000000000000000000000000000000";
  -- uart_rx_fsm.vhd:57:21
  n146_o <= n134_o when n116_o = '0' else n207_q;
  -- uart_rx_fsm.vhd:57:21
  n147_o <= n135_o when n116_o = '0' else n208_q;
  -- uart_rx_fsm.vhd:57:21
  n148_o <= n137_o when n116_o = '0' else n209_q;
  -- uart_rx_fsm.vhd:57:21
  n149_o <= n139_o when n116_o = '0' else state;
  -- uart_rx_fsm.vhd:57:21
  n150_o <= n141_o when n116_o = '0' else n120_o;
  -- uart_rx_fsm.vhd:57:21
  n151_o <= n143_o when n116_o = '0' else n112_o;
  -- uart_rx_fsm.vhd:57:21
  n152_o <= n145_o when n116_o = '0' else n118_o;
  -- uart_rx_fsm.vhd:55:21
  n153_o <= n146_o when n114_o = '0' else n207_q;
  -- uart_rx_fsm.vhd:55:21
  n154_o <= n147_o when n114_o = '0' else n208_q;
  -- uart_rx_fsm.vhd:55:21
  n156_o <= n148_o when n114_o = '0' else '1';
  -- uart_rx_fsm.vhd:55:21
  n157_o <= n149_o when n114_o = '0' else state;
  -- uart_rx_fsm.vhd:55:21
  n158_o <= n150_o when n114_o = '0' else address_fsm;
  -- uart_rx_fsm.vhd:55:21
  n159_o <= n151_o when n114_o = '0' else n112_o;
  -- uart_rx_fsm.vhd:55:21
  n160_o <= n152_o when n114_o = '0' else real_address;
  -- uart_rx_fsm.vhd:52:17
  n162_o <= '1' when state = "10" else '0';
  -- uart_rx_fsm.vhd:76:40
  n164_o <= std_logic_vector (unsigned (counter) + unsigned'("00000000000000000000000000000001"));
  -- uart_rx_fsm.vhd:77:32
  n166_o <= '1' when n164_o = "00000000000000000000000000000001" else '0';
  -- uart_rx_fsm.vhd:77:21
  n168_o <= n210_q when n166_o = '0' else '1';
  -- uart_rx_fsm.vhd:80:32
  n170_o <= '1' when n164_o = "00000000000000000000000000000010" else '0';
  -- uart_rx_fsm.vhd:80:21
  n172_o <= n207_q when n170_o = '0' else "00";
  -- uart_rx_fsm.vhd:80:21
  n174_o <= n208_q when n170_o = '0' else "000";
  -- uart_rx_fsm.vhd:80:21
  n176_o <= n168_o when n170_o = '0' else '0';
  -- uart_rx_fsm.vhd:80:21
  n178_o <= state when n170_o = '0' else "00";
  -- uart_rx_fsm.vhd:75:17
  n180_o <= '1' when state = "11" else '0';
  n181_o <= n180_o & n162_o & n110_o & n96_o;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n183_o <=
    n172_o when "1000",
    n153_o when "0100",
    n102_o when "0010",
    n86_o when "0001",
    "XX" when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n185_o <=
    n174_o when "1000",
    n154_o when "0100",
    n104_o when "0010",
    n208_q when "0001",
    "XXX" when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n187_o <=
    n209_q when "1000",
    n156_o when "0100",
    n209_q when "0010",
    n209_q when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n189_o <=
    n176_o when "1000",
    n210_q when "0100",
    n210_q when "0010",
    n210_q when "0001",
    'X' when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n191_o <=
    n178_o when "1000",
    n157_o when "0100",
    n106_o when "0010",
    n88_o when "0001",
    "XX" when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n193_o <=
    address_fsm when "1000",
    n158_o when "0100",
    address_fsm when "0010",
    n90_o when "0001",
    "XXX" when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n195_o <=
    n164_o when "1000",
    n159_o when "0100",
    n108_o when "0010",
    n92_o when "0001",
    (31 downto 0 => 'X') when others;
  -- uart_rx_fsm.vhd:33:12
  with n181_o select n197_o <=
    real_address when "1000",
    n160_o when "0100",
    real_address when "0010",
    n94_o when "0001",
    (31 downto 0 => 'X') when others;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n207_q <= n183_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n208_q <= n185_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n209_q <= n187_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n210_q <= n189_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n211_q <= n191_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n212_q <= n193_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n213_q <= n195_o;
    end if;
  end process;
  -- uart_rx_fsm.vhd:32:9
  process (clk)
  begin
    if rising_edge (clk) then
      n214_q <= n197_o;
    end if;
  end process;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal memory : std_logic_vector (7 downto 0);
  signal address : std_logic_vector (2 downto 0);
  signal midbit : std_logic;
  signal fsm_dout : std_logic_vector (1 downto 0);
  signal fsm_address_out : std_logic_vector (2 downto 0);
  signal fsm_midbit : std_logic;
  signal fsm_dout_vld : std_logic;
  signal n11_o : std_logic;
  signal n20_o : std_logic_vector (7 downto 0);
  signal n21_q : std_logic_vector (7 downto 0);
  signal n22_o : std_logic;
  signal n26_o : std_logic;
  signal n27_o : std_logic;
  signal n28_o : std_logic;
  signal n29_o : std_logic;
  signal n30_o : std_logic;
  signal n31_o : std_logic;
  signal n32_o : std_logic;
  signal n33_o : std_logic;
  signal n34_o : std_logic;
  signal n35_o : std_logic;
  signal n36_o : std_logic;
  signal n37_o : std_logic;
  signal n38_o : std_logic;
  signal n39_o : std_logic;
  signal n40_o : std_logic;
  signal n41_o : std_logic;
  signal n42_o : std_logic;
  signal n43_o : std_logic;
  signal n44_o : std_logic;
  signal n45_o : std_logic;
  signal n46_o : std_logic;
  signal n47_o : std_logic;
  signal n48_o : std_logic;
  signal n49_o : std_logic;
  signal n50_o : std_logic;
  signal n51_o : std_logic;
  signal n52_o : std_logic;
  signal n53_o : std_logic;
  signal n54_o : std_logic;
  signal n55_o : std_logic;
  signal n56_o : std_logic;
  signal n57_o : std_logic;
  signal n58_o : std_logic;
  signal n59_o : std_logic;
  signal n60_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic;
  signal n64_o : std_logic;
  signal n65_o : std_logic;
  signal n66_o : std_logic;
  signal n67_o : std_logic;
  signal n68_o : std_logic_vector (7 downto 0);
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= n21_q;
  wrap_DOUT_VLD <= fsm_dout_vld;
  -- uart_rx.vhd:23:12
  memory <= n68_o; -- (isignal)
  -- uart_rx.vhd:24:12
  address <= fsm_address_out; -- (isignal)
  -- uart_rx.vhd:25:12
  midbit <= fsm_midbit; -- (signal)
  -- uart_rx.vhd:31:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    din => wrap_DIN,
    dout => open,
    address_out => fsm_address_out,
    midbit => fsm_midbit,
    dout_vld => fsm_dout_vld);
  -- uart_rx.vhd:43:12
  n11_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- uart_rx.vhd:25:12
  n20_o <= n21_q when midbit = '0' else memory;
  -- uart_rx.vhd:43:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n21_q <= n20_o;
    end if;
  end process;
  -- uart_rx.vhd:25:12
  n22_o <= n11_o and midbit;
  -- uart_rx.vhd:47:17
  n26_o <= address (2);
  -- uart_rx.vhd:47:17
  n27_o <= not n26_o;
  -- uart_rx.vhd:47:17
  n28_o <= address (1);
  -- uart_rx.vhd:47:17
  n29_o <= not n28_o;
  -- uart_rx.vhd:47:17
  n30_o <= n27_o and n29_o;
  -- uart_rx.vhd:47:17
  n31_o <= n27_o and n28_o;
  -- uart_rx.vhd:47:17
  n32_o <= n26_o and n29_o;
  -- uart_rx.vhd:47:17
  n33_o <= n26_o and n28_o;
  -- uart_rx.vhd:47:17
  n34_o <= address (0);
  -- uart_rx.vhd:47:17
  n35_o <= not n34_o;
  -- uart_rx.vhd:47:17
  n36_o <= n30_o and n35_o;
  -- uart_rx.vhd:47:17
  n37_o <= n30_o and n34_o;
  -- uart_rx.vhd:47:17
  n38_o <= n31_o and n35_o;
  -- uart_rx.vhd:47:17
  n39_o <= n31_o and n34_o;
  -- uart_rx.vhd:47:17
  n40_o <= n32_o and n35_o;
  -- uart_rx.vhd:47:17
  n41_o <= n32_o and n34_o;
  -- uart_rx.vhd:47:17
  n42_o <= n33_o and n35_o;
  -- uart_rx.vhd:47:17
  n43_o <= n33_o and n34_o;
  n44_o <= memory (0);
  -- uart_rx.vhd:47:17
  n45_o <= n36_o and n22_o;
  -- uart_rx.vhd:47:17
  n46_o <= n44_o when n45_o = '0' else wrap_DIN;
  n47_o <= memory (1);
  -- uart_rx.vhd:47:17
  n48_o <= n37_o and n22_o;
  -- uart_rx.vhd:47:17
  n49_o <= n47_o when n48_o = '0' else wrap_DIN;
  n50_o <= memory (2);
  -- uart_rx.vhd:47:17
  n51_o <= n38_o and n22_o;
  -- uart_rx.vhd:47:17
  n52_o <= n50_o when n51_o = '0' else wrap_DIN;
  n53_o <= memory (3);
  -- uart_rx.vhd:47:17
  n54_o <= n39_o and n22_o;
  -- uart_rx.vhd:47:17
  n55_o <= n53_o when n54_o = '0' else wrap_DIN;
  n56_o <= memory (4);
  -- uart_rx.vhd:47:17
  n57_o <= n40_o and n22_o;
  -- uart_rx.vhd:47:17
  n58_o <= n56_o when n57_o = '0' else wrap_DIN;
  n59_o <= memory (5);
  -- uart_rx.vhd:47:17
  n60_o <= n41_o and n22_o;
  -- uart_rx.vhd:47:17
  n61_o <= n59_o when n60_o = '0' else wrap_DIN;
  n62_o <= memory (6);
  -- uart_rx.vhd:47:17
  n63_o <= n42_o and n22_o;
  -- uart_rx.vhd:47:17
  n64_o <= n62_o when n63_o = '0' else wrap_DIN;
  n65_o <= memory (7);
  -- uart_rx.vhd:47:17
  n66_o <= n43_o and n22_o;
  -- uart_rx.vhd:47:17
  n67_o <= n65_o when n66_o = '0' else wrap_DIN;
  n68_o <= n67_o & n64_o & n61_o & n58_o & n55_o & n52_o & n49_o & n46_o;
end rtl;
