-------------------------------------------------------------------------------
-- lab 7 top: pin-level wrapper (active-low KEYs, reset synchronizer)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic;                      -- KEY0, active low
    execute_n: in  std_logic;                      -- KEY1, active low
    led      : out std_logic_vector(3 downto 0);
    bcd_0    : out std_logic_vector(6 downto 0);
    bcd_1    : out std_logic_vector(6 downto 0);
    bcd_2    : out std_logic_vector(6 downto 0)
  );
end top;

architecture struct of top is

  component processor is
    port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      execute  : in  std_logic;
      led      : out std_logic_vector(3 downto 0);
      bcd_0    : out std_logic_vector(6 downto 0);
      bcd_1    : out std_logic_vector(6 downto 0);
      bcd_2    : out std_logic_vector(6 downto 0)
    );
  end component;

  signal rst_flop1 : std_logic := '1';
  signal reset     : std_logic := '1';
  signal execute   : std_logic;

begin

  -- reset: asserts immediately, releases synchronously to the 50 MHz clock
  reset_sync : process (clk, reset_n)
  begin
    if reset_n = '0' then
      rst_flop1 <= '1';
      reset     <= '1';
    elsif rising_edge(clk) then
      rst_flop1 <= '0';
      reset     <= rst_flop1;
    end if;
  end process;

  execute <= not execute_n;

  u_proc : processor
    port map (
      clk     => clk,
      reset   => reset,
      execute => execute,
      led     => led,
      bcd_0   => bcd_0,
      bcd_1   => bcd_1,
      bcd_2   => bcd_2
    );

end struct;