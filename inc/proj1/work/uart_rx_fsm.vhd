-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Tomáš Sitarčík (xsitar06)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK   : in std_logic;
       DIN   : in std_logic;
       DOUT : out std_logic_vector(1 downto 0) := "00";
       ADDRESS_OUT : out std_logic_vector(2 downto 0) := "000";
       MIDBIT : out std_logic := '0';
       DOUT_VLD : out std_logic := '0'
    );
end entity;



architecture behavioral of UART_RX_FSM is
    type STATE_TYPE is (START_BIT_WAIT, START_BIT_READ, DATA_READ, STOP_BIT);
    signal state : STATE_TYPE := START_BIT_WAIT;
    signal address_fsm : std_logic_vector(2 downto 0) := "000";
    shared variable counter : integer := 0;
    shared variable real_address : integer := 0;

begin
    process (CLK) begin
        if rising_edge(CLK) then
           case state is 
                when START_BIT_WAIT =>
                    if DIN = '0' then
                        counter := 0;
                        real_address := 0;
                        address_fsm <= "000";
                        state <= START_BIT_READ;
                        DOUT <= "01";
                    end if;
                    
                when START_BIT_READ =>
                    counter := counter + 1;
                    if counter = 15 then
                        state <= DATA_READ;
                        DOUT <= "10";
                        counter := 0;
                        ADDRESS_OUT <= "000";
                    end if;
                
                when DATA_READ =>

                    counter := counter + 1;
                    if counter = 8 then
                        MIDBIT <= '1';
                    elsif counter = 15 then
                        real_address := real_address + 1;
                        address_fsm <= address_fsm + 1;
                    
                    elsif real_address = 8 and counter = 9 then
                        state <= STOP_BIT;
                        DOUT <= "11";
                        counter := 0;
                        real_address := 0;
                        address_fsm <= "000";
                        MIDBIT <= '0';
                    elsif counter = 16 then
                        counter := 0;
                        ADDRESS_OUT <= address_fsm;
                    else 
                        MIDBIT <= '0';
                    end if;

                when STOP_BIT =>
                    counter := counter + 1;
                    if counter = 1 then
                        DOUT_VLD <= '1';
                    end if;
                    if counter = 2 then
                        DOUT_VLD <= '0';
                        state <= START_BIT_WAIT;
                        DOUT <= "00";
                        ADDRESS_OUT <= "000";
                    end if;
            end case;
        
        end if;
    end process;

end architecture;
