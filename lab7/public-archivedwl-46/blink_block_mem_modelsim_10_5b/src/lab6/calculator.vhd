library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity calculator is
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
end calculator;

architecture struct of calculator is

  signal switch_sync    : std_logic_vector(7 downto 0);
  signal op_flop1       : std_logic_vector(1 downto 0) := (others => '0');
  signal op_sync        : std_logic_vector(1 downto 0) := (others => '0');
  signal execute_edge   : std_logic;
  signal addr_ptr       : std_logic_vector(1 downto 0) := "00";
  signal next_addr      : std_logic_vector(1 downto 0);
  signal mem_dout       : std_logic_vector(7 downto 0);
  signal alu_result     : std_logic_vector(7 downto 0);
  signal display_padded : std_logic_vector(11 downto 0);
  signal dd_ones        : std_logic_vector(3 downto 0);
  signal dd_tens        : std_logic_vector(3 downto 0);
  signal dd_hundreds    : std_logic_vector(3 downto 0);
  signal dd_thousands   : std_logic_vector(3 downto 0);

begin

  u_sync_switch : synchronizer_8bit
    port map (clk => clk, reset => reset, async_in => switch, sync_out => switch_sync);

  op_sync_proc : process (clk, reset)
  begin
    if reset = '1' then
      op_flop1 <= (others => '0');
      op_sync  <= (others => '0');
    elsif rising_edge(clk) then
      op_flop1 <= op;
      op_sync  <= op_flop1;
    end if;
  end process;

  u_sync_execute : rising_edge_synchronizer
    port map (clk => clk, reset => reset, input => execute, edge => execute_edge);

  next_addr <= "01" when addr_ptr = "00" else
               "10" when addr_ptr = "01" else
               "11" when addr_ptr = "10" else
               "01";

  u_memory : memory
    generic map (addr_width => 2, data_width => 8)
    port map (
      clk  => clk,
      we   => execute_edge,
      addr => next_addr,
      din  => alu_result,
      dout => mem_dout
    );

  u_alu : alu
    port map (
      reset  => reset,
      a      => mem_dout,
      b      => switch_sync,
      op     => op_sync,
      result => alu_result
    );

  addr_reg : process (clk, reset)
  begin
    if reset = '1' then
      addr_ptr <= "00";
    elsif rising_edge(clk) then
      if execute_edge = '1' then
        addr_ptr <= next_addr;
      end if;
    end if;
  end process;

  led <= '0' & addr_ptr;

  display_padded <= "0000" & mem_dout;

  u_dd : double_dabble
    port map (
      binary_in => display_padded,
      ones      => dd_ones,
      tens      => dd_tens,
      hundreds  => dd_hundreds,
      thousands => dd_thousands
    );

  u_seg_0 : seven_seg port map (bcd => dd_ones,     seven_seg_out => bcd_0);
  u_seg_1 : seven_seg port map (bcd => dd_tens,     seven_seg_out => bcd_1);
  u_seg_2 : seven_seg port map (bcd => dd_hundreds, seven_seg_out => bcd_2);

end struct;