library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  generic (
    addr_width : integer := 2;
    data_width : integer := 4
  );
  port (
    clk  : in  std_logic;
    we   : in  std_logic;
    addr : in  std_logic_vector(addr_width - 1 downto 0);
    din  : in  std_logic_vector(data_width - 1 downto 0);
    dout : out std_logic_vector(data_width - 1 downto 0)
  );
end memory;

architecture beh of memory is
  type mem_array is array (0 to (2**addr_width) - 1) of std_logic_vector(data_width - 1 downto 0);
  signal mem : mem_array := (others => (others => '0'));
begin

  write_proc : process (clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        mem(to_integer(unsigned(addr))) <= din;
      end if;
    end if;
  end process;

  dout <= (others => '0') when (unsigned(addr) = 0) else mem(to_integer(unsigned(addr)));

end beh;