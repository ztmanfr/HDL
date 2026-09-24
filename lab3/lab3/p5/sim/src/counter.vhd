library ieee;
use ieee.std_logic_1164.all;      

entity counter is
  generic (
    max_count       : integer range 0 to 100 := 3
  );
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    seven_seg_out   : out std_logic_vector(6 downto 0)
  );  
end counter;  

architecture uut of counter  is

  signal enable   : std_logic;
  signal sum_sig  : std_logic_vector(3 downto 0);
  signal sum      : std_logic_vector(3 downto 0) := "0000";

begin
  process (clk, reset)
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
end uut;