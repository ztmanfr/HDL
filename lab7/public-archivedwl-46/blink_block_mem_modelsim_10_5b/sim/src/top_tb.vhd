-------------------------------------------------------------------------------
-- lab 7 top test bench: presses the execute button once per ROM instruction
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arch of top_tb is

  component top is
    port (
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      execute_n: in  std_logic;
      led      : out std_logic_vector(3 downto 0);
      bcd_0    : out std_logic_vector(6 downto 0);
      bcd_1    : out std_logic_vector(6 downto 0);
      bcd_2    : out std_logic_vector(6 downto 0)
    );
  end component;

  constant period : time := 20 ns;
  signal clk      : std_logic := '0';
  signal reset_n  : std_logic := '0';
  signal execute  : std_logic := '0';
  signal execute_n: std_logic := '1';
  signal led      : std_logic_vector(3 downto 0);
  signal bcd_0    : std_logic_vector(6 downto 0);
  signal bcd_1    : std_logic_vector(6 downto 0);
  signal bcd_2    : std_logic_vector(6 downto 0);

begin

  execute_n <= not execute;   -- testbench drives active-high, DUT wants active-low

  clock : process
  begin
    clk <= not clk;
    wait for period / 2;
  end process;

  stim : process
  begin
    reset_n <= '0';
    wait for 5 * period;
    reset_n <= '1';
    wait for 10 * period;

    for i in 1 to 8 loop           -- 6 programmed instructions + 2 extra
      execute <= '1';
      wait for 10 * period;        -- hold long enough for the 3-flop sync
      execute <= '0';
      wait for 30 * period;        -- let ROM / sync / memory settle
    end loop;

    wait;
  end process;

  uut : top
    port map (
      clk     => clk,
      reset_n => reset_n,
      execute_n => execute_n,
      led     => led,
      bcd_0   => bcd_0,
      bcd_1   => bcd_1,
      bcd_2   => bcd_2
    );

end arch;