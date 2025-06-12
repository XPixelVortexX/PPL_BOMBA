-- Minesweeper Game Logic: VHDL Code
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Game_Logic is
    generic (
        FIELD_SIZE : integer := 25;
        NUM_MINES  : integer := 5
    );
    Port (
        clk             : in  std_logic;
        reset           : in  std_logic;
        start_game      : in  std_logic;
        selected_index  : in  integer range 0 to FIELD_SIZE-1;
        reveal_request  : in  std_logic;
        minefield       : in  std_logic_vector(FIELD_SIZE-1 downto 0); 
        game_active     : out std_logic;
        hit_mine        : out std_logic;
        win             : out std_logic
    );
end Game_Logic;

architecture Behavioral of game_logic is

    signal revealed      : std_logic_vector(FIELD_SIZE-1 downto 0) := (others => '0');
    signal game_running  : std_logic := '0';
    signal revealed_safe : integer := 0;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            revealed      <= (others => '0');
            game_running  <= '0';
            hit_mine     <= '0';
            win           <= '0';
            revealed_safe <= 0;

        elsif rising_edge(clk) then
            if start_game = '1' then
                revealed      <= (others => '0');
                game_running  <= '1';
                hit_mine     <= '0';
                win           <= '0';
                revealed_safe <= 0;

            elsif game_running = '1' and reveal_request = '1' then
                if revealed(selected_index) = '0' then
                    revealed(selected_index) <= '1';

                    if minefield(selected_index) = '1' then
                        hit_mine     <= '1';
                        game_running <= '0';
                    else
                        revealed_safe <= revealed_safe + 1;
                        if revealed_safe + 1 = FIELD_SIZE - NUM_MINES then
                            win <= '1';
                            game_running <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    game_active <= game_running;

end Behavioral;
