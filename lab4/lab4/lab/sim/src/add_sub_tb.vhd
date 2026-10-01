library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_tb is
end add_sub_tb;

architecture arch of add_sub_tb is

  component add_sub is
    port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      a           : in  std_logic_vector(2 downto 0);
      b           : in  std_logic_vector(2 downto 0);
      add_btn     : in  std_logic;
      sub_btn     : in  std_logic;
      a_bcd       : out std_logic_vector(6 downto 0);
      b_bcd       : out std_logic_vector(6 downto 0);
      result_bcd  : out std_logic_vector(6 downto 0)
    );
  end component;

  constant period : time := 20 ns;

  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal a          : std_logic_vector(2 downto 0) := "000";
  signal b          : std_logic_vector(2 downto 0) := "000";
  signal add_btn    : std_logic := '0';
  signal sub_btn    : std_logic := '0';
  signal a_bcd      : std_logic_vector(6 downto 0);
  signal b_bcd      : std_logic_vector(6 downto 0);
  signal result_bcd : std_logic_vector(6 downto 0);

begin

  clock : process
  begin
    clk <= not clk;
    wait for period/2;
  end process;

  async_reset : process
  begin
    wait for 2 * period;
    reset <= '0';
    wait;
  end process;

  stimulus : process
  begin
    report "****************** add_sub testbench start ****************";
    wait for 3 * period;

    for i in 0 to 7 loop
      a <= std_logic_vector(to_unsigned(i, 3));
      for j in 0 to 7 loop
        b <= std_logic_vector(to_unsigned(j, 3));
        wait for 2 * period;

        add_btn <= '1';
        wait for period;
        add_btn <= '0';
        wait for 2 * period;

        sub_btn <= '1';
        wait for period;
        sub_btn <= '0';
        wait for 2 * period;
      end loop;
    end loop;

    report "****************** add_sub testbench stop ****************";
    wait;
  end process;

  uut : add_sub
    port map (
      clk        => clk,
      reset      => reset,
      a          => a,
      b          => b,
      add_btn    => add_btn,
      sub_btn    => sub_btn,
      a_bcd      => a_bcd,
      b_bcd      => b_bcd,
      result_bcd => result_bcd
    );

end arch;