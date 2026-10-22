library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_add_sub is
  generic (
    bits : integer := 3
  );
  port (
    a      : in  std_logic_vector(bits-1 downto 0);
    b      : in  std_logic_vector(bits-1 downto 0);
    sel    : in  std_logic;
    result : out std_logic_vector(bits downto 0)
  );
end entity generic_add_sub;

architecture beh of generic_add_sub is
  signal a_ext : unsigned(bits downto 0);
  signal b_ext : unsigned(bits downto 0);
begin

  a_ext <= '0' & unsigned(a);
  b_ext <= '0' & unsigned(b);

  process (a_ext, b_ext, sel)
  begin
    if sel = '0' then
      result <= std_logic_vector(a_ext + b_ext);
    else
      result <= std_logic_vector(a_ext - b_ext);
    end if;
  end process;

end architecture beh;