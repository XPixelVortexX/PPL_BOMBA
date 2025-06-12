library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_logic_tb is
end game_logic_tb;

architecture behavior of game_logic_tb is

  -- Unit Under Test
  component game_logic
    port (
      clk           : in  std_logic;
      x, y          : in  std_logic_vector(2 downto 0);
      click         : in  std_logic;
      bomb_map      : in  std_logic_vector(63 downto 0);
      read_data     : in  std_logic_vector(1 downto 0);
      write_data    : out std_logic_vector(1 downto 0);
      write_enable  : out std_logic
    );
  end component;

  -- Signale
  signal clk         : std_logic := '0';
  signal x, y        : std_logic_vector(2 downto 0) := (others => '0');
  signal click       : std_logic := '0';
  signal bomb_map    : std_logic_vector(63 downto 0) := (others => '0');
  signal read_data   : std_logic_vector(1 downto 0) := "00";
  signal write_data  : std_logic_vector(1 downto 0);
  signal write_enable: std_logic;

  -- Adresse berechnen (Zeile * 8 + Spalte)
  function addr(x, y: std_logic_vector(2 downto 0)) return integer is
  begin
    return to_integer(unsigned(y) * 8 + unsigned(x));
  end function;

begin

  -- DUT instanzieren
  uut: game_logic
    port map (
      clk          => clk,
      x            => x,
      y            => y,
      click        => click,
      bomb_map     => bomb_map,
      read_data    => read_data,
      write_data   => write_data,
      write_enable => write_enable
    );

  -- Clock: 100 MHz
  clk_proc: process
  begin
    while true loop
      clk <= '0'; wait for 5 ns;
      clk <= '1'; wait for 5 ns;
    end loop;
  end process;

  -- Stimuli
  stim_proc: process
  begin
    wait for 20 ns;

    -- ? Fall 1: freies Feld (read_data = "00", bomb_map = '0')
    x <= "001"; y <= "001";
    read_data <= "00";
    bomb_map(addr(x,y)) <= '0';  -- keine Bombe
    click <= '1'; wait for 20 ns;
    click <= '0'; wait for 40 ns;

    -- ? Fall 2: Bombenfeld (read_data = "00", bomb_map = '1')
    x <= "010"; y <= "001";
    read_data <= "00";
    bomb_map(addr(x,y)) <= '1';  -- Bombe
    click <= '1'; wait for 20 ns;
    click <= '0'; wait for 40 ns;

    -- ? Fall 3: bereits aufgedeckt (read_data ? "00")
    x <= "001"; y <= "001";
    read_data <= "01";  -- bereits offen
    click <= '1'; wait for 20 ns;
    click <= '0'; wait for 40 ns;

    wait;
  end process;

end behavior;