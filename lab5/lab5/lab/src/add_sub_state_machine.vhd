library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_state_machine is
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    switch  : in  std_logic_vector(7 downto 0);
    btn     : in  std_logic;
    led     : out std_logic_vector(3 downto 0);
    bcd_0   : out std_logic_vector(6 downto 0);
    bcd_1   : out std_logic_vector(6 downto 0);
    bcd_2   : out std_logic_vector(6 downto 0)
  );
end entity add_sub_state_machine;

architecture struct of add_sub_state_machine is

  component synchronizer_8bit is
    port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      async_in : in  std_logic_vector(7 downto 0);
      sync_out : out std_logic_vector(7 downto 0)
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
    generic (bits : integer := 8);
    port (
      a      : in  std_logic_vector(bits-1 downto 0);
      b      : in  std_logic_vector(bits-1 downto 0);
      sel    : in  std_logic;
      result : out std_logic_vector(bits downto 0)
    );
  end component;

  component double_dabble is
    port (
      result_padded : in  std_logic_vector(11 downto 0);
      ones          : out std_logic_vector(3 downto 0);
      tens          : out std_logic_vector(3 downto 0);
      hundreds      : out std_logic_vector(3 downto 0)
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

  constant STATE_INPUT_A  : std_logic_vector(3 downto 0) := "0001";
  constant STATE_INPUT_B  : std_logic_vector(3 downto 0) := "0010";
  constant STATE_DISP_SUM : std_logic_vector(3 downto 0) := "0100";
  constant STATE_DISP_DIFF: std_logic_vector(3 downto 0) := "1000";

  signal btn_n          : std_logic;
  signal sync8bit        : std_logic_vector(7 downto 0);
  signal btnedge         : std_logic;
  signal state_reg       : std_logic_vector(3 downto 0) := STATE_INPUT_A;
  signal aval            : std_logic_vector(7 downto 0) := (others => '0');
  signal bval            : std_logic_vector(7 downto 0) := (others => '0');
  signal res             : std_logic_vector(8 downto 0);
  signal display_value   : std_logic_vector(8 downto 0);
  signal result_padded   : std_logic_vector(11 downto 0);
  signal hun             : std_logic_vector(3 downto 0);
  signal ten             : std_logic_vector(3 downto 0);
  signal one             : std_logic_vector(3 downto 0);

begin

  btn_n <= not btn;

  u_sync8 : synchronizer_8bit
    port map (clk => clk, reset => reset, async_in => switch, sync_out => sync8bit);

  u_edge : rising_edge_synchronizer
    port map (clk => clk, reset => reset, async_in => btn_n, pulse_out => btnedge);

  fsm : process (clk, reset)
  begin
    if reset = '1' then
      state_reg <= STATE_INPUT_A;
      aval      <= (others => '0');
      bval      <= (others => '0');
    elsif rising_edge(clk) then
      if btnedge = '1' then
        case state_reg is
          when STATE_INPUT_A =>
            aval      <= sync8bit;
            state_reg <= STATE_INPUT_B;
          when STATE_INPUT_B =>
            bval      <= sync8bit;
            state_reg <= STATE_DISP_SUM;
          when STATE_DISP_SUM =>
            state_reg <= STATE_DISP_DIFF;
          when STATE_DISP_DIFF =>
            state_reg <= STATE_INPUT_A;
          when others =>
            state_reg <= STATE_INPUT_A;
        end case;
      end if;
    end if;
  end process fsm;

  led <= state_reg;

  u_add_sub : generic_add_sub
    generic map (bits => 8)
    port map (a => aval, b => bval, sel => state_reg(3), result => res);

  display_mux : process (state_reg, sync8bit, res)
  begin
    case state_reg is
      when STATE_INPUT_A | STATE_INPUT_B =>
        display_value <= '0' & sync8bit;
      when others =>
        display_value <= res;
    end case;
  end process display_mux;

  result_padded <= "000" & display_value;

  u_dd : double_dabble
    port map (result_padded => result_padded, ones => one, tens => ten, hundreds => hun);

  u_seg_hun : seven_seg
    port map (clk => clk, reset => reset, bcd => hun, seven_seg_out => bcd_2);

  u_seg_ten : seven_seg
    port map (clk => clk, reset => reset, bcd => ten, seven_seg_out => bcd_1);

  u_seg_one : seven_seg
    port map (clk => clk, reset => reset, bcd => one, seven_seg_out => bcd_0);

end architecture struct;