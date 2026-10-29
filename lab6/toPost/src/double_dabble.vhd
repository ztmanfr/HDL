-------------------------------------------------------------------------------
-- Dr. Kaputa
-- double_dabble: 12-bit binary to 4-digit BCD (thousands, hundreds, tens, ones)
-- https://en.wikipedia.org/wiki/Double_dabble
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity double_dabble is
  port (
    binary_in                : in  std_logic_vector(11 downto 0);
    ones                     : out std_logic_vector(3 downto 0);
    tens                     : out std_logic_vector(3 downto 0);
    hundreds                 : out std_logic_vector(3 downto 0);
    thousands                : out std_logic_vector(3 downto 0)
  );
end double_dabble;

architecture beh of double_dabble is
begin

  bcd1: process(binary_in)
    variable temp : STD_LOGIC_VECTOR (11 downto 0);
    variable bcd : UNSIGNED (15 downto 0) := (others => '0');
  begin
    bcd := (others => '0');
    temp(11 downto 0) := binary_in;

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
      if bcd(15 downto 12) > 4 then
        bcd(15 downto 12) := bcd(15 downto 12) + 3;
      end if;

      bcd := bcd(14 downto 0) & temp(11);
      temp := temp(10 downto 0) & '0';
    end loop;

    ones      <= STD_LOGIC_VECTOR(bcd(3 downto 0));
    tens      <= STD_LOGIC_VECTOR(bcd(7 downto 4));
    hundreds  <= STD_LOGIC_VECTOR(bcd(11 downto 8));
    thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
  end process bcd1;

end beh;