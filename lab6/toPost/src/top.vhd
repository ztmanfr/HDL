library ieee;
use ieee.std_logic_1164.all;
use work.components.all;

entity top is
  port (
    clk      : in  std_logic;
    reset_n  : in  std_logic;
    mr       : in  std_logic;
    ms       : in  std_logic;
    execute  : in  std_logic;
    switch   : in  std_logic_vector(7 downto 0);
    op       : in  std_logic_vector(1 downto 0);
    led      : out std_logic_vector(3 downto 0);
    bcd_0    : out std_logic_vector(6 downto 0);
    bcd_1    : out std_logic_vector(6 downto 0);
    bcd_2    : out std_logic_vector(6 downto 0)
  );
end top;

architecture struct of top is
  signal reset    : std_logic;
  signal calc_led : std_logic_vector(2 downto 0);
begin

  reset <= not reset_n;

  u_calc : calculator
    port map (
      clk     => clk,
      reset   => reset,
      execute => execute,
      switch  => switch,
      op      => op,
      led     => calc_led,
      bcd_0   => bcd_0,
      bcd_1   => bcd_1,
      bcd_2   => bcd_2
    );

  led(2 downto 0) <= calc_led;
  led(3)          <= '0';

end struct;