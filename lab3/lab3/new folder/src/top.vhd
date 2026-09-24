library ieee;
use ieee.std_logic_1164.all;

entity top is
  generic (
    max_count       : integer := 49999999
  );
  port (
    clk             : in  std_logic;
    reset           : in  std_logic;
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );
end entity top;

architecture struct of top is

  component generic_counter is
    generic (max_count : integer := 3);
    port (
      clk     : in  std_logic;
      reset   : in  std_logic;
      output  : out std_logic
    );
  end component;

  component generic_adder_beh is
    generic (bits : integer := 4);
    port (
      a     : in  std_logic_vector(bits-1 downto 0);
      b     : in  std_logic_vector(bits-1 downto 0);
      cin   : in  std_logic;
      sum   : out std_logic_vector(bits-1 downto 0);
      cout  : out std_logic
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

  signal enable   : std_logic;
  signal sum_sig  : std_logic_vector(3 downto 0);
  signal sum      : std_logic_vector(3 downto 0) := "0000";

begin

  u_counter : generic_counter
    generic map (max_count => max_count)
    port map (clk => clk, reset => reset, output => enable);

  u_adder : generic_adder_beh
    generic map (bits => 4)
    port map (a => sum, b => "0001", cin => '0', sum => sum_sig, cout => open);

  sum_register : process (clk, reset)
  begin
    if (reset = '1') then
      sum <= "0000";
    elsif (clk'event and clk = '1') then
      if (enable = '1') then
        if (sum = "1001") then
          sum <= "0000";
        else
          sum <= sum_sig;
        end if;
      end if;
    end if;
  end process;

  u_seg : seven_seg
    port map (clk => clk, reset => reset, bcd => sum, seven_seg_out => seven_seg_out);

end architecture struct;