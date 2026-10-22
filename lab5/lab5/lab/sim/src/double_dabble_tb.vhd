-------------------------------------------------------------------------------
-- Dr. Kaputa
-- double_dabble test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity double_dabble_tb is
end double_dabble_tb;

architecture arch of double_dabble_tb is

<<<<<<< HEAD
  component add_sub_state_machine is
    port (
      clk    : in  std_logic;
      reset  : in  std_logic;
      switch : in  std_logic_vector(7 downto 0);
      btn    : in  std_logic;
      led    : out std_logic_vector(3 downto 0);
      bcd_0  : out std_logic_vector(6 downto 0);
      bcd_1  : out std_logic_vector(6 downto 0);
      bcd_2  : out std_logic_vector(6 downto 0)
    );
  end component;

  constant period : time := 20 ns;

  signal clk    : std_logic := '0';
  signal reset  : std_logic := '1';
  signal switch : std_logic_vector(7 downto 0) := (others => '0');
  signal btn    : std_logic := '1';   -- idle high, like the real KEY pushbutton
  signal led    : std_logic_vector(3 downto 0);
  signal bcd_0  : std_logic_vector(6 downto 0);
  signal bcd_1  : std_logic_vector(6 downto 0);
  signal bcd_2  : std_logic_vector(6 downto 0);
=======
component double_dabble is
  port (
      clk         : in  std_logic;
      reset       : in  std_logic;
      a           : in  std_logic_vector(2 downto 0);
      b           : in  std_logic_vector(2 downto 0);
      btn         : in  std_logic;
    result_padded           : in  std_logic_vector(11 downto 0); 
    ones                    : out std_logic_vector(3 downto 0);
    tens                    : out std_logic_vector(3 downto 0);
    hundreds                : out std_logic_vector(3 downto 0)
  );  
end component; 
>>>>>>> 1ab6a95aa02ffd46c90bee7d9df2f67c267cd031

  constant period : time := 20 ns;

  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal a          : std_logic_vector(7 downto 0) := "0000000";
  signal b          : std_logic_vector(7 downto 0) := "0000000";
  signal btn        : std_logic := '1';


begin
    variable temp : STD_LOGIC_VECTOR (11 downto 0);
    variable bcd : UNSIGNED (15 downto 0) := (others => '0');

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

 bcd := (others => '0');
    temp(11 downto 0) := result_padded;

    wait for 3 * period;

        a <= "00000101";
        b <= "00000010";
        wait for 2 * period;

        btn <= '1';
        wait for 3 * period;

for i in 0 to 11 loop
      if bcd(3 downto 0) > 4 then
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      if bcd(7 downto 4) > 4 then
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
      if bcd(11 downto 8) > 4 then
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;
      bcd := bcd(14 downto 0) & temp(11);
      result_padded := temp(10 downto 0) & '0';
    end loop;

        btn <= '0';
        wait for 3 * period;
      end loop;
    end loop;



    wait;
  end process;

<<<<<<< HEAD
  clock : process
  begin
    clk <= not clk;
    wait for period/2;
  end process;

  stimulus : process

    -- press and release btn, long enough for the edge synchronizer to catch it
    procedure press_btn is
    begin
      btn <= '0';
      wait for 3 * period;
      btn <= '1';
      wait for 3 * period;
    end procedure;

    -- drive switch to a value and let the 8-bit synchronizer settle
    procedure set_switch(val : integer) is
    begin
      switch <= std_logic_vector(to_unsigned(val, 8));
      wait for 3 * period;
    end procedure;

    -- run one full A -> B -> sum -> diff cycle, starting and ending in input_a
    procedure run_case(a_val, b_val : integer) is
    begin
      -- input_a: enter A
      set_switch(a_val);
      press_btn;             -- captures A, moves to input_b

      -- input_b: enter B
      set_switch(b_val);
      press_btn;             -- captures B, moves to disp_sum

      -- disp_sum: hold here so the sum can be read on the displays
      wait for 10 * period;
      press_btn;             -- moves to disp_diff

      -- disp_diff: hold here so the difference can be read
      wait for 10 * period;
      press_btn;             -- moves back to input_a
    end procedure;

  begin
    report "****************** add_sub_state_machine testbench start ****************";

    reset <= '1';
    wait for 3 * period;
    reset <= '0';
    wait for 2 * period;

    run_case(5, 2);       -- SUM=7,   DIFF=3
    run_case(2, 5);       -- SUM=7,   DIFF=509
    run_case(200, 100);   -- SUM=300, DIFF=100
    run_case(100, 200);   -- SUM=300, DIFF=412

    report "****************** add_sub_state_machine testbench stop ****************";
    wait;
  end process;

  uut : add_sub_state_machine
    port map (
      clk    => clk,
      reset  => reset,
      switch => switch,
      btn    => btn,
      led    => led,
      bcd_0  => bcd_0,
      bcd_1  => bcd_1,
      bcd_2  => bcd_2
    );

=======
uut: double_dabble  
  port map(
      clk        => clk,
      reset      => reset,
      a          => a,
      b          => b,
      btn        => btn,
    result_padded       => "000011001000",
    ones                => open,
    tens                => open,
    hundreds            => open
  );
>>>>>>> 1ab6a95aa02ffd46c90bee7d9df2f67c267cd031
end arch;