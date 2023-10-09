-- uart_tx.vhd: UART controller - transmitting (TX) side
-- Author(s): Lukas Kekely (ikekely@fit.vutbr.cz)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_TX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic_vector(7 downto 0);
        DIN_VLD  : in std_logic;
        DIN_RDY  : out std_logic;
        DOUT     : out std_logic
    );
end entity;



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_TX is
    
    signal din_reg : std_logic_vector(8-1 downto 0);
    signal din_ce : std_logic;
    signal input_rdy : std_logic;
    signal data_mux : std_logic;
    signal start_mux : std_logic;
    signal stop_mux : std_logic;
    signal cycle_cnt : std_logic_vector(4-1 downto 0);
    signal cycle_cnt_end : std_logic;
    signal data_cnt : std_logic_vector(3-1 downto 0);
    signal data_cnt_end : std_logic;
    signal start : std_logic;
    signal stop : std_logic;
    signal count : std_logic;
    signal data_count : std_logic;
    
begin

    -- Input data register
    din_register: process(CLK)
    begin
        if rising_edge(CLK) then
            if din_ce = '1' then
                din_reg <= DIN;
            end if;
        end if;
    end process;
    
    -- Output data path MUXes
    with data_cnt select
         data_mux <= 
            din_reg(0) when "000",
            din_reg(1) when "001",
            din_reg(2) when "010",
            din_reg(3) when "011",
            din_reg(4) when "100",
            din_reg(5) when "101",
            din_reg(6) when "110",
            din_reg(7) when "111",
            'X' when others;
            
    start_mux <= '0' when start = '1' else data_mux;
    
    stop_mux <= '1' when stop = '1' else start_mux;
    
    -- Counters&comparators for clock cycles and data bits
    cycles_counter: process(CLK)
    begin
        if rising_edge(CLK) then
            if count = '1' then
                cycle_cnt <= cycle_cnt + 1;
            else
                cycle_cnt <= (others => '0');
            end if;
        end if;
    end process;
    
    cycle_cnt_end <= '1' when cycle_cnt = "1111" else '0';
    
    data_counter: process(CLK)
    begin
        if rising_edge(CLK) then
            if data_count = '1' then
                if cycle_cnt_end = '1' then
                    data_cnt <= data_cnt + 1;
                end if;
            else
                data_cnt <= (others => '0');
            end if;
        end if;
    end process;
    
    data_cnt_end <= '1' when data_cnt = "111" else '0';
    
    -- Instance of TX FSM
    fsm: entity work.UART_TX_FSM
    port map (
        CLK        => CLK,
        RST        => RST,
        VLD        => DIN_VLD,
        BIT_END    => cycle_cnt_end,
        WORD_END   => data_cnt_end,
        START      => start,
        STOP       => stop,
        COUNT      => count,
        DATA_COUNT => data_count,
        RDY        => input_rdy
    );
    
    -- Interconnecting signals
    din_ce <= DIN_VLD and input_rdy;
    DIN_RDY <= input_rdy;
    DOUT <= stop_mux;

end architecture;
