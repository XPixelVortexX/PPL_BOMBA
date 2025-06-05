library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
  port (
    clk         : in  std_logic;
    btn_up      : in  std_logic;
    btn_down    : in  std_logic;
    btn_left    : in  std_logic;
    btn_right   : in  std_logic;
    btn_act     : in  std_logic;
    
    vga_r       : out std_logic_vector(3 downto 0);
    vga_g       : out std_logic_vector(3 downto 0);
    vga_b       : out std_logic_vector(3 downto 0);
    hsync       : out std_logic;
    vsync       : out std_logic
  );
end top_level;

architecture strukturell of top_level is

  -- Komponenten deklarieren
  component controls
    port (
      clk, rst      : in  std_logic;
      btn_up        : in  std_logic;
      btn_down      : in  std_logic;
      btn_left      : in  std_logic;
      btn_right     : in  std_logic;
      btn_act       : in  std_logic;
      x             : out std_logic_vector(2 downto 0);
      y             : out std_logic_vector(2 downto 0);
      click         : out std_logic
    );
  end component;

  component random_gen
    port (
      clk           : in  std_logic;
      bomb_map      : out std_logic_vector(63 downto 0)
    );
  end component;

  component memory
    port (
      clk           : in  std_logic;
      write_enable  : in  std_logic;
      x, y          : in  std_logic_vector(2 downto 0);
      write_data    : in  std_logic_vector(1 downto 0);
      read_data     : out std_logic_vector(1 downto 0)
    );
  end component;

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

  component display
    port (
      clk           : in  std_logic;
      bomb_map      : in  std_logic_vector(63 downto 0);
      vram          : in  std_logic_vector(1 downto 0);
      x, y          : in  std_logic_vector(2 downto 0);
      vga_r         : out std_logic_vector(3 downto 0);
      vga_g         : out std_logic_vector(3 downto 0);
      vga_b         : out std_logic_vector(3 downto 0);
      hsync         : out std_logic;
      vsync         : out std_logic
    );
  end component;

  -- Interne Signale
  signal x, y           : std_logic_vector(2 downto 0);
  signal click          : std_logic;
  signal bomb_map       : std_logic_vector(63 downto 0);
  signal write_enable   : std_logic;
  signal write_data     : std_logic_vector(1 downto 0);
  signal read_data      : std_logic_vector(1 downto 0);

begin

  u_controls: controls
    port map (
      clk       => clk,
      rst       => '0',  -- optionaler Reset
      btn_up    => btn_up,
      btn_down  => btn_down,
      btn_left  => btn_left,
      btn_right => btn_right,
      btn_act   => btn_act,
      x         => x,
      y         => y,
      click     => click
    );

  u_random_gen: random_gen
    port map (
      clk       => clk,
      bomb_map  => bomb_map
    );

  u_game_logic: game_logic
    port map (
      clk         => clk,
      x           => x,
      y           => y,
      click       => click,
      bomb_map    => bomb_map,
      read_data   => read_data,
      write_data  => write_data,
      write_enable=> write_enable
    );

  u_memory: memory
    port map (
      clk         => clk,
      write_enable=> write_enable,
      x           => x,
      y           => y,
      write_data  => write_data,
      read_data   => read_data
    );

  u_display: display
    port map (
      clk     => clk,
      bomb_map => bomb_map,
      vram     => read_data,
      x        => x,
      y        => y,
      vga_r    => vga_r,
      vga_g    => vga_g,
      vga_b    => vga_b,
      hsync    => hsync,
      vsync    => vsync
    );

end strukturell;
