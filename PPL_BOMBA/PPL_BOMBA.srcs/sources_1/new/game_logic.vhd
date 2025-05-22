-- Minesweeper Game Logic: VHDL Code
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity minesweeper_game is
    Port ( clk             : in  STD_LOGIC;
           rst             : in  STD_LOGIC;
           start_game      : in  STD_LOGIC;
           x, y            : in  STD_LOGIC_VECTOR(3 downto 0);  -- x, y Position des Spielfelds
           open_cell       : in  STD_LOGIC;  -- Signal zum Öffnen eines Feldes
           mine_field      : out STD_LOGIC_VECTOR(15 downto 0); -- Minenfeld (16 Felder)
           game_over       : out STD_LOGIC;
           game_won        : out STD_LOGIC;
           cell_revealed   : out STD_LOGIC_VECTOR(15 downto 0); -- Sichtbare Felder
           neighbor_count  : out STD_LOGIC_VECTOR(3 downto 0) -- Anzahl benachbarter Minen
           );
end minesweeper_game;

architecture Behavioral of minesweeper_game is
    -- Konstanten
    constant NUM_CELLS : integer := 16;  -- Anzahl der Felder (4x4)
    
    -- Signal zur Speicherung der Mineninformationen
    type field_type is array (0 to NUM_CELLS-1) of STD_LOGIC; -- 0 für leer, 1 für Mine
    signal mine_array : field_type := (others => '0');
    signal revealed_array : field_type := (others => '0');  -- Sichtbare Felder
    signal neighbor_count_array : array(0 to NUM_CELLS-1) of integer := (others => 0);  -- Anzahl benachbarter Minen
    signal game_active : STD_LOGIC := '0';  -- Spielstatus (aktiv/inaktiv)

    -- Funktion zum Berechnen der benachbarten Minen für jedes Feld
    procedure calculate_neighbors is
    begin
        for i in 0 to NUM_CELLS-1 loop
            neighbor_count_array(i) := 0;
            -- Berechnen der benachbarten Minen
            for dx in -1 to 1 loop
                for dy in -1 to 1 loop
                    if (dx = 0 and dy = 0) then
                        -- Nicht das Feld selbst
                        next;
                    end if;
                    -- Berechnen der Nachbarn unter Berücksichtigung der Spielfeldgrenzen
                    if (i mod 4 + dx >= 0 and i mod 4 + dx < 4 and i / 4 + dy >= 0 and i / 4 + dy < 4) then
                        if (mine_array(i + dx + 4 * dy) = '1') then
                            neighbor_count_array(i) := neighbor_count_array(i) + 1;
                        end if;
                    end if;
                end loop;
            end loop;
        end loop;
    end procedure;

begin
    -- Prozess für das Spielverhalten
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset des Spiels
            mine_array <= (others => '0');
            revealed_array <= (others => '0');
            game_active <= '0';
            game_over <= '0';
            game_won <= '0';
            calculate_neighbors;
        elsif rising_edge(clk) then
            if start_game = '1' then
                -- Minen zufällig setzen (hier für den Test hartkodiert)
                mine_array(0) <= '1';  -- Beispiel: Mine auf Position 0
                mine_array(5) <= '1';  -- Beispiel: Mine auf Position 5
                mine_array(10) <= '1'; -- Beispiel: Mine auf Position 10
                calculate_neighbors;
                game_active <= '1';
            end if;

            -- Öffnen eines Feldes
            if open_cell = '1' then
                if revealed_array(to_integer(unsigned(x & y))) = '0' then
                    revealed_array(to_integer(unsigned(x & y))) <= '1'; -- Feld aufgedeckt
                    -- Überprüfen, ob Mine getroffen wurde
                    if mine_array(to_integer(unsigned(x & y))) = '1' then
                        game_over <= '1'; -- Spiel verloren
                    end if;
                end if;
            end if;

            -- Überprüfen, ob das Spiel gewonnen wurde
            if game_active = '1' then
                -- Spiel gewonnen, wenn alle Felder ohne Minen aufgedeckt wurden
                if revealed_array = (others => '1') then
                    game_won <= '1';
                end if;
            end if;
        end if;
    end process;
end Behavioral;
