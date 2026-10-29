library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_synchronizer is
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;
    input  : in  std_logic;
    edge   : out std_logic
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
      flop1 <= input;
      flop2 <= flop1;
      flop3 <= flop2;
    end if;
  end process;

  edge <= flop2 and not flop3;
end beh;