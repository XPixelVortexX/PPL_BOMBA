library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controls_tb is
end controls_tb;

architecture behavior of controls_tb is

  -- Unit Under Test
  component controls
    port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      btn_up    : in  std_logic;
      btn_down  : in  std_logic;
      btn_left  : in  std_logic;
      btn_right : in  std_logic;
      btn_act   : in  std_logic;
      x         : out std_logic_vector(2 downto 0);
      y         : out std_logic_vector(2 downto 0);
      click     : out std_logic
    );
  end component;

  -- Signale zur Verbindung mit UUT
  signal clk       : std_logic := '0';
  signal rst       : std_logic := '0';
  signal btn_up    : std_logic := '0';
  signal btn_down  : std_logic := '0';
  signal btn_left  : std_logic := '0';
  signal btn_right : std_logic := '0';
  signal btn_act   : std_logic := '0';
  signal x         : std_logic_vector(2 downto 0);
  signal y         : std_logic_vector(2 downto 0);
  signal click     : std_logic;

begin

  -- DUT instanziieren
  uut: controls
    port map (
      clk       => clk,
      rst       => rst,
      btn_up    => btn_up,
      btn_down  => btn_down,
      btn_left  => btn_left,
      btn_right => btn_right,
      btn_act   => btn_act,
      x         => x,
      y         => y,
      click     => click
    );

  -- Clock: 100 MHz
  clk_process : process
  begin
    while true loop
      clk <= '0'; wait for 5 ns;
      clk <= '1'; wait for 5 ns;
    end loop;
  end process;

  -- Stimuli
  stim_proc: process
  begin
    -- Reset
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait for 20 ns;

    -- Rechts
    btn_right <= '1'; wait for 20 ns;
    btn_right <= '0'; wait for 40 ns;

    -- Unten
    btn_down <= '1'; wait for 20 ns;
    btn_down <= '0'; wait for 40 ns;

    -- Links
    btn_left <= '1'; wait for 20 ns;
    btn_left <= '0'; wait for 40 ns;

    -- Oben
    btn_up <= '1'; wait for 20 ns;
    btn_up <= '0'; wait for 40 ns;
  
    -- Aktiviere Feld (click)
    btn_act <= '1'; wait for 20 ns;
    btn_act <= '0'; wait for 40 ns;

    wait for 100 ns;
    wait;
  end process;
  
  end behavior;