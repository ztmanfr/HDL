library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_tb is
end calculator_tb;

architecture arch of calculator_tb is

  component calculator is
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      execute       : in  std_logic;
      switch        : in  std_logic_vector(7 downto 0);
      op            : in  std_logic_vector(1 downto 0);
      led           : out std_logic_vector(2 downto 0);
      bcd_0         : out std_logic_vector(6 downto 0);
      bcd_1         : out std_logic_vector(6 downto 0);
      bcd_2         : out std_logic_vector(6 downto 0)
    );
  end component;

  constant period : time := 20 ns;

  signal clk     : std_logic := '0';
  signal reset   : std_logic := '1';
  signal execute : std_logic := '0';
  signal switch  : std_logic_vector(7 downto 0) := (others => '0');
  signal op      : std_logic_vector(1 downto 0) := "00";
  signal led     : std_logic_vector(2 downto 0);
  signal bcd_0   : std_logic_vector(6 downto 0);
  signal bcd_1   : std_logic_vector(6 downto 0);
  signal bcd_2   : std_logic_vector(6 downto 0);

begin

  clock : process
  begin
    clk <= not clk;
    wait for period/2;
  end process;

  stimulus : process

    procedure press_execute is
    begin
      execute <= '1';
      wait for 3 * period;
      execute <= '0';
      wait for 3 * period;
    end procedure;

    procedure set_switch(val : integer) is
    begin
      switch <= std_logic_vector(to_unsigned(val, 8));
      wait for 3 * period;
    end procedure;

    procedure set_op(code : std_logic_vector(1 downto 0)) is
    begin
      op <= code;
      wait for 3 * period;
    end procedure;

    procedure run_op(b_val : integer; opcode : std_logic_vector(1 downto 0)) is
    begin
      set_switch(b_val);
      set_op(opcode);
      press_execute;
      wait for 5 * period;
    end procedure;

  begin
    report "****************** calculator testbench start ****************";

    reset <= '1';
    wait for 3 * period;
    reset <= '0';
    wait for 2 * period;

    run_op(5,  "00");
    run_op(3,  "00");
    run_op(20, "01");
    run_op(10, "10");
    run_op(4,  "11");
    run_op(5,  "11");

    reset <= '1';
    wait for 3 * period;
    reset <= '0';
    wait for 5 * period;

    report "****************** calculator testbench stop ****************";
    wait;
  end process;

  uut : calculator
    port map (
      clk     => clk,
      reset   => reset,
      execute => execute,
      switch  => switch,
      op      => op,
      led     => led,
      bcd_0   => bcd_0,
      bcd_1   => bcd_1,
      bcd_2   => bcd_2
    );

end arch;