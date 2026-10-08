library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arch of top_tb is

component top is
  generic (max_count : integer := 49999999);
  port (
    clk             : in  std_logic;
    reset           : in  std_logic;
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );
end component;

constant period       : time := 20ns;
signal clk            : std_logic := '0';
signal reset          : std_logic := '1';
signal seven_seg_out  : std_logic_vector(6 downto 0);

begin

clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process;

async_reset: process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
end process;

uut: top
  generic map (max_count => 3)
  port map(
    clk            => clk,
    reset          => reset,
    seven_seg_out  => seven_seg_out
  );

end arch;