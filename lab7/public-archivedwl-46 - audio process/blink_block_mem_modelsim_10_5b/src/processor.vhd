-------------------------------------------------------------------------------
-- lab 7 processor: reuses lab 6 alu / memory / synchronizers / double_dabble / seven_seg
-- (all unchanged). Only the wiring differs from lab 6's calculator.
--
-- PLAYBACK = true  : each press shows the next ROM value (instr(7:0)) as is
-- PLAYBACK = false : each press runs the ALU (latest result op operand)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity processor is
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;                      -- active high, already synchronized
    execute  : in  std_logic;                      -- active high, asynchronous button
    led      : out std_logic_vector(3 downto 0);
    bcd_0    : out std_logic_vector(6 downto 0);
    bcd_1    : out std_logic_vector(6 downto 0);
    bcd_2    : out std_logic_vector(6 downto 0)
  );
end processor;

architecture struct of processor is

  constant PLAYBACK : boolean := true;

  component blink_rom is
    port (
      address : in  std_logic_vector(4 downto 0);
      clock   : in  std_logic := '1';
      q       : out std_logic_vector(9 downto 0)
    );
  end component;

  signal exec_edge      : std_logic;
  signal write_en       : std_logic := '0';
  signal pc             : unsigned(4 downto 0) := (others => '0');
  signal instr          : std_logic_vector(9 downto 0);
  signal addr_ptr       : std_logic_vector(1 downto 0) := "00";
  signal next_addr      : std_logic_vector(1 downto 0);
  signal mem_dout       : std_logic_vector(7 downto 0);
  signal alu_result     : std_logic_vector(7 downto 0);
  signal result_reg     : std_logic_vector(7 downto 0) := (others => '0');
  signal display_padded : std_logic_vector(11 downto 0);
  signal dd_ones        : std_logic_vector(3 downto 0);
  signal dd_tens        : std_logic_vector(3 downto 0);
  signal dd_hundreds    : std_logic_vector(3 downto 0);
  signal dd_thousands   : std_logic_vector(3 downto 0);

begin

  u_sync_execute : rising_edge_synchronizer
    port map (clk => clk, reset => reset, input => execute, edge => exec_edge);

  u_rom : blink_rom
    port map (address => std_logic_vector(pc), clock => clk, q => instr);

  next_addr <= "01" when addr_ptr = "00" else
               "10" when addr_ptr = "01" else
               "11" when addr_ptr = "10" else
               "01";

  u_memory : memory
    generic map (addr_width => 2, data_width => 8)
    port map (
      clk  => clk,
      we   => write_en,
      addr => addr_ptr,
      din  => result_reg,
      dout => mem_dout
    );

  u_alu : alu
    port map (
      reset  => reset,
      a      => mem_dout,
      b      => instr(7 downto 0),
      op     => instr(9 downto 8),
      result => alu_result
    );

  control : process (clk, reset)
  begin
    if reset = '1' then
      pc         <= (others => '0');
      addr_ptr   <= "00";
      result_reg <= (others => '0');
      write_en   <= '0';
    elsif rising_edge(clk) then
      write_en <= exec_edge;
      if exec_edge = '1' then
        pc       <= pc + 1;
        addr_ptr <= next_addr;
        if PLAYBACK then
          result_reg <= instr(7 downto 0);   -- show the stored value as is
        else
          result_reg <= alu_result;          -- normal lab 7 behavior
        end if;
      end if;
    end if;
  end process;

  led(1 downto 0) <= addr_ptr;              -- which memory slot holds the latest result
  led(3 downto 2) <= instr(9 downto 8);     -- opcode of the instruction being presented

  display_padded <= "0000" & result_reg;

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