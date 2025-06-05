library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity minesweeper_controls is
  Port (
    clk       : in  std_logic;                         -- Clock signal
    rst       : in  std_logic;                         -- Reset button
    btn_up    : in  std_logic;                         -- Move cursor up
    btn_down  : in  std_logic;                         -- Move cursor down
    btn_left  : in  std_logic;                         -- Move cursor left
    btn_right : in  std_logic;                         -- Move cursor right
    btn_act   : in  std_logic;                         -- Activate current field
    x         : out std_logic_vector(2 downto 0);      -- X-position (0 to 7)
    y         : out std_logic_vector(2 downto 0);      -- Y-position (0 to 7)
    click     : out std_logic                          -- One-clock pulse for activation
  );
end minesweeper_controls;

architecture behavioral of minesweeper_controls is

  type state_type is (idle, check, move, activate, wait_release);
  signal state : state_type := idle;

  signal xpos, ypos : unsigned(2 downto 0) := (others => '0');
  signal click_reg  : std_logic := '0';

begin

  process(clk, rst)
  begin
    if rst = '1' then
      xpos <= (others => '0');
      ypos <= (others => '0');
      state <= idle;
      click_reg <= '0';

    elsif rising_edge(clk) then
      case state is

        when idle =>
          click_reg <= '0';
          if btn_up = '1' or btn_down = '1' or btn_left = '1' or btn_right = '1' then
            state <= move;
          elsif btn_act = '1' then
            state <= activate;
          end if;

        when move =>
          if btn_up = '1' and ypos < 7 then
            ypos <= ypos + 1;
          elsif btn_down = '1' and ypos > 0 then
            ypos <= ypos - 1;
          elsif btn_left = '1' and xpos > 0 then
            xpos <= xpos - 1;
          elsif btn_right = '1' and xpos < 7 then
            xpos <= xpos + 1;
          end if;
          state <= wait_release;

        when activate =>
          click_reg <= '1';
          state <= wait_release;

        when wait_release =>
          if btn_up = '0' and btn_down = '0' and btn_left = '0' and btn_right = '0' and btn_act = '0' then
            state <= idle;
          end if;

        when others =>
          state <= idle;

      end case;
    end if;
  end process;

  x <= std_logic_vector(xpos);
  y <= std_logic_vector(ypos);
  click <= click_reg;

end behavioral;
