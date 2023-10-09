-- uart_tx_fsm.vhd: UART controller - finite state machine controlling TX side
-- Author(s): Lukas Kekely (ikekely@fit.vutbr.cz) 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_TX_FSM is
    port(
       CLK        : in std_logic;
       RST        : in std_logic;
       VLD        : in std_logic;
       BIT_END    : in std_logic;
       WORD_END   : in std_logic;
       START      : out std_logic;
       STOP       : out std_logic;
       COUNT      : out std_logic;
       DATA_COUNT : out std_logic;
       RDY        : out std_logic
    );
end entity;



architecture behavioral of UART_TX_FSM is

    type t_state is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : t_state;
    signal next_state : t_state;

begin

    -- Present state register
    state_register: process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    -- Next state combinatorial logic
    next_state_logic: process(state, VLD, BIT_END, WORD_END)
    begin
        next_state <= state; -- default behaviour, FSM stay in the same state
        case state is
            when IDLE =>
                if VLD = '1' then
                    next_state <= START_BIT;
                end if;
            when START_BIT =>
                if BIT_END = '1' then
                    next_state <= DATA_BITS;
                end if;
            when DATA_BITS =>
                if BIT_END = '1' and WORD_END = '1' then
                    next_state <= STOP_BIT;
                end if;
            when STOP_BIT =>
                if BIT_END = '1' then
                    next_state <= IDLE;
                end if;
        end case;
    end process;

    -- Output combinatorial logic
    output_logic: process(state)
    begin
        RDY        <= '0'; -- default output values
        START      <= '0';
        STOP       <= '0';
        COUNT      <= '1';
        DATA_COUNT <= '0';
        case state is
            when IDLE =>
                RDY   <= '1';
                STOP  <= '1';
                COUNT <= '0';
            when START_BIT =>
                START <= '1';
            when DATA_BITS =>
                DATA_COUNT <= '1';
            when STOP_BIT =>
                STOP <= '1';
        end case;
    end process;

end architecture;
