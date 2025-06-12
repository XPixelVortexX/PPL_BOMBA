library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
  port (
    clk           : in  std_logic;
    write_enable  : in  std_logic;
    x, y          : in  std_logic_vector(2 downto 0);  -- 3 Bit je Richtung = 8×8 = 64 Felder
    write_data    : in  std_logic_vector(1 downto 0);  -- z.?B. Zustand eines Feldes (zwei Bits)
    read_data     : out std_logic_vector(1 downto 0)
  );
end memory;

architecture behavioral of memory is

  type ram_type is array (0 to 63) of std_logic_vector(1 downto 0);
  signal ram : ram_type := (others => (others => '0'));

  signal addr : integer range 0 to 63;

begin

  -- Adressberechnung aus x und y
  addr <= to_integer(unsigned(y) * 8 + unsigned(x));  -- Zeile * 8 + Spalte

  process(clk)
  begin
    if rising_edge(clk) then
      if write_enable = '1' then
        ram(addr) <= write_data;
      end if;
    end if;
  end process;

  read_data <= ram(addr);

end behavioral;