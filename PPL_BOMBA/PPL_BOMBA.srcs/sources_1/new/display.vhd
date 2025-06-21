library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is
  port (
    clk       : in  std_logic;
    bomb_map  : in  std_logic_vector(63 downto 0);
    vram      : in  std_logic_vector(1 downto 0);
    x, y      : in  std_logic_vector(2 downto 0);
    vga_r     : out std_logic_vector(3 downto 0);
    vga_g     : out std_logic_vector(3 downto 0);
    vga_b     : out std_logic_vector(3 downto 0);
    hsync     : out std_logic;
    vsync     : out std_logic
  );
end display;

architecture behavioral of display is

  signal h_count     : integer range 0 to 799 := 0;  -- Horizontaler Zähler
  signal v_count     : integer range 0 to 524 := 0;  -- Vertikaler Zähler
  signal video_on    : std_logic;
  signal div_clk_cnt : integer range 0 to 1 := 0;
  signal div_clk     : std_logic := '0';

  constant CELL_SIZE : integer := 40; -- Tbd (Test)
  constant GRID_SIZE : integer := 8;

begin

  --Clock Divider 
  process(clk)
  begin
    if rising_edge(clk)then
        if div_clk_cnt = 1 then 
            div_clk_cnt <= 0;
            div_clk <= not div_clk;
        else 
            div_clk_cnt <= div_clk_cnt + 1;
        end if;
    end if;
  end process;

  -- Horizontalzähler
  process(div_clk)
  begin
    if rising_edge(div_clk) then
      if h_count = 799 then
        h_count <= 0;
        if v_count = 524 then
          v_count <= 0;
        else
          v_count <= v_count + 1;
        end if;
      else
        h_count <= h_count + 1;
      end if;
    end if;
  end process;

  -- VGA-Synchronisation (640�480 @ 60Hz, 25MHz Takt)
  hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
  vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';

  -- Sichtbarer Bereich (Video ON nur bei aktiver Bildfläche)
  video_on <= '1' when (h_count < 640 and v_count < 480) else '0';

  -- Spielfeld-Anzeige
  process(div_clk)
    variable grid_x, grid_y : integer;
    variable index          : integer;
  begin
    if rising_edge(div_clk) then
      if video_on = '1' then
        -- Berechne in welcher Zelle wir sind
        grid_x := (h_count - 100) / CELL_SIZE; -- Startoffset nach links: 100
        grid_y := (v_count - 50) / CELL_SIZE;  -- Startoffset nach oben: 50

        if grid_x >= 0 and grid_x < GRID_SIZE and
           grid_y >= 0 and grid_y < GRID_SIZE then

          index := grid_y * GRID_SIZE + grid_x;
          
          -- Falls Bombe (bit gesetzt), dann rot anzeigen
          if bomb_map(index) = '1' then
            vga_r <= "1111";
            vga_g <= "0000";
            vga_b <= "0000";
          else
            vga_r <= "0000";
            vga_g <= "1111";
            vga_b <= "0000";
          end if;
        else
          -- Hintergrund außerhalb des Spielfelds
          vga_r <= "1000";
          vga_g <= "1000";
          vga_b <= "1000";
        end if;
      else
        vga_r <= "0000";
        vga_g <= "0000";
        vga_b <= "0000";
      end if;
    end if;
  end process;

end behavioral;
