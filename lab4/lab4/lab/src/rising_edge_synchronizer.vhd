-------------------------------------------------------------------------------
-- rising edge synchronizer + edge detector (for async pushbuttons)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_synchronizer is
  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    async_in  : in  std_logic;
    pulse_out : out std_logic
  );
end rising_edge_synchronizer;

architecture beh of rising_edge_synchronizer is
signal flop1 : std_logic;
signal flop2 : std_logic;
signal flop3 : std_logic;
begin
  triple_flop : process (reset, clk)
  begin
    if reset = '1' then
      flop1 <= '0';
      flop2 <= '0';
      flop3 <= '0';
    elsif rising_edge(clk) then
      flop1 <= async_in;  -- metastability guard
      flop2 <= flop1;     -- stable synchronized value
      flop3 <= flop2;     -- one cycle delayed, for edge compare
    end if;
  end process;

  -- one-clock-wide pulse on the rising edge of the synchronized button
  pulse_out <= flop2 and not flop3;
end beh;