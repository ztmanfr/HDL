library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
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
end entity add_sub;

architecture struct of add_sub is

  component synchronizer_3bit is
    port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      async_in : in  std_logic_vector(2 downto 0);
      sync_out : out std_logic_vector(2 downto 0)
    );
  end component;

  component rising_edge_synchronizer is
    port (
      clk       : in  std_logic;
      reset     : in  std_logic;
      async_in  : in  std_logic;
      pulse_out : out std_logic
    );
  end component;

  component generic_add_sub is
    generic (bits : integer := 3);
    port (
      a      : in  std_logic_vector(bits-1 downto 0);
      b      : in  std_logic_vector(bits-1 downto 0);
      sel    : in  std_logic;
      result : out std_logic_vector(bits downto 0)
    );
  end component;

  component seven_seg is
    port (
      clk             : in  std_logic;
      reset           : in  std_logic;
      bcd             : in  std_logic_vector(3 downto 0);
      seven_seg_out   : out std_logic_vector(6 downto 0)
    );
  end component;

  signal a_sync      : std_logic_vector(2 downto 0);
  signal b_sync      : std_logic_vector(2 downto 0);
  signal add_pulse   : std_logic;
  signal sub_pulse   : std_logic;
  signal ensel      : std_logic;
  signal fin_result  : std_logic_vector(3 downto 0);
  signal result_reg  : std_logic_vector(3 downto 0) := "0000";
  signal a_disp      : std_logic_vector(3 downto 0);
  signal b_disp      : std_logic_vector(3 downto 0);

begin

  u_sync_a : synchronizer_3bit
    port map (clk => clk, reset => reset, async_in => a, sync_out => a_sync);

  u_sync_b : synchronizer_3bit
    port map (clk => clk, reset => reset, async_in => b, sync_out => b_sync);

  u_sync_add : rising_edge_synchronizer
    port map (clk => clk, reset => reset, async_in => add_btn, pulse_out => add_pulse);

  u_sync_sub : rising_edge_synchronizer
    port map (clk => clk, reset => reset, async_in => sub_btn, pulse_out => sub_pulse);

  ensel <= sub_pulse;

  u_add_sub : generic_add_sub
    generic map (bits => 3)
    port map (a => a_sync, b => b_sync, sel => ensel, result => fin_result);

  result_register : process (clk, reset)
  begin
    if (reset = '1') then
      result_reg <= "0000";
    elsif (clk'event and clk = '1') then
      if (add_pulse = '1' or sub_pulse = '1') then
        result_reg <= fin_result;
      end if;
    end if;
  end process;

  a_disp <= '0' & a_sync;
  b_disp <= '0' & b_sync;

  u_seg_a : seven_seg
    port map (clk => clk, reset => reset, bcd => a_disp, seven_seg_out => a_bcd);

  u_seg_b : seven_seg
    port map (clk => clk, reset => reset, bcd => b_disp, seven_seg_out => b_bcd);

  u_seg_result : seven_seg
    port map (clk => clk, reset => reset, bcd => result_reg, seven_seg_out => result_bcd);

end architecture struct;