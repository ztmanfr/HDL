-------------------------------------------------------------------------------
-- Dr. Kaputa
-- double_dabble test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity double_dabble_tb is
end double_dabble_tb;

architecture arch of double_dabble_tb is

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
end arch;