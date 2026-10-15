-------------------------------------------------------------------------------
-- Dr. Kaputa
-- double_dabble: 12-bit binary to 3-digit BCD (hundreds, tens, ones)
-- https://en.wikipedia.org/wiki/Double_dabble
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity double_dabble is
  port (
    result_padded           : in  std_logic_vector(11 downto 0);
    ones                    : out std_logic_vector(3 downto 0);
    tens                    : out std_logic_vector(3 downto 0);
    hundreds                : out std_logic_vector(3 downto 0)
  );
end double_dabble;

architecture beh of double_dabble is
begin

  bcd1: process(result_padded)
    -- temporary variable
    variable temp : STD_LOGIC_VECTOR (11 downto 0);
    variable bcd : UNSIGNED (15 downto 0) := (others => '0');
  begin
    bcd := (others => '0');
    temp(11 downto 0) := result_padded;

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
      temp := temp(10 downto 0) & '0';
    end loop;

    ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));
    tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));
  end process bcd1;

end beh;