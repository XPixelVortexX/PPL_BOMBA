library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display is
  port (
    clk     : in  std_logic; -- 25 MHz VGA-Takt
    vga_r   : out std_logic_vector(3 downto 0);
    vga_g   : out std_logic_vector(3 downto 0);
    vga_b   : out std_logic_vector(3 downto 0);
    hsync   : out std_logic;
    vsync   : out std_logic
  );
end display;

architecture behavioral of display is

  signal h_count     : integer range 0 to 799 := 0;  -- Horizontaler Zähler
  signal v_count     : integer range 0 to 524 := 0;  -- Vertikaler Zähler
  signal video_on    : std_logic;

begin

  -- Horizontalzähler
  process(clk)
  begin
    if rising_edge(clk) then
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

  -- VGA-Synchronisation (640×480 @ 60Hz, 25MHz Takt)
  hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
  vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';

  -- Sichtbarer Bereich (Video ON nur bei aktiver Bildfläche)
  video_on <= '1' when (h_count < 640 and v_count < 480) else '0';

  -- Rechteckanzeige (ein grünes Viereck bei Position 270,190 bis 370,290)
  process(clk)
  begin
    if rising_edge(clk) then
      if video_on = '1' and
         h_count >= 270 and h_count < 370 and
         v_count >= 190 and v_count < 290 then
        vga_r <= "0000";
        vga_g <= "1111"; -- Grün
        vga_b <= "0000";
      else
        vga_r <= "0000";
        vga_g <= "0000";
        vga_b <= "0000"; -- Hintergrund: Schwarz
      end if;
    end if;
  end process;

end behavioral;
