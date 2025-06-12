library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_logic is
  port (
    clk           : in  std_logic;
    x, y          : in  std_logic_vector(2 downto 0);
    click         : in  std_logic;
    bomb_map      : in  std_logic_vector(63 downto 0);
    read_data     : in  std_logic_vector(1 downto 0);  -- z.?B. 00=verdeckt, 01=offen, 10=markiert
    write_data    : out std_logic_vector(1 downto 0);
    write_enable  : out std_logic
  );
end game_logic;

architecture behavioral of game_logic is
  signal addr : integer range 0 to 63;
begin

  -- Adresse berechnen
  addr <= to_integer(unsigned(y) * 8 + unsigned(x));

  process(clk)
  begin
    if rising_edge(clk) then
      if click = '1' then
        if read_data = "00" then  -- Noch nicht aufgedeckt
          if bomb_map(addr) = '1' then
            -- Bombe getroffen
            write_data <= "11";  -- Beispiel: 11 = Bombe
          else
            -- Feld ist sicher
            write_data <= "01";  -- Beispiel: 01 = Offen
          end if;
          write_enable <= '1';
        else
          write_enable <= '0';
        end if;
      else
        write_enable <= '0';
      end if;
    end if;
  end process;

end behavioral;
