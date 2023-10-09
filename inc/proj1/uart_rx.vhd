-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Tomáš Sitarčík (xsitar06)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    signal fsm_in      : std_logic;
    signal fsm_out     : std_logic_vector(1 downto 0) := "00";
    signal memory      : std_logic_vector(7 downto 0) := "00000000";
    signal address     : std_logic_vector(2 downto 0) := "000";
    signal midbit      : std_logic;
    signal vld         : std_logic;
    
begin

    -- Instance of RX FSM
    FSM: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        DIN => DIN,
        DOUT => fsm_out,
        ADDRESS_OUT => address,
        DOUT_VLD => DOUT_VLD,
        MIDBIT => midbit
    );
    
    process (CLK) begin
       
        if rising_edge(CLK) then

            if midbit = '1' then
                --report "Value of address is: " & integer'image(to_integer(unsigned(address))) & " DIN is " & std_logic'image(DIN);
                memory(to_integer(unsigned(address))) <= DIN;
                DOUT <= memory;
            end if;

        end if;

    end process;

end architecture;
