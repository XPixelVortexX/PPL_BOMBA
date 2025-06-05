library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity-Definition: Schnittstelle des Bomben-Generators
entity bomb_generator_8x8 is
    port (
        clk    : in std_logic;                         -- Takt
        rst    : in std_logic;                         -- Reset
        start  : in std_logic;                         -- Startsignal zur Initialisierung
        bombs  : out std_logic_vector(63 downto 0);    -- Ausgabe: 64-Bit Spielfeld (8x8)
        done   : out std_logic                         -- Signal: Generierung abgeschlossen
    );
end bomb_generator_8x8;

-- Architektur der Schaltung
architecture behavioral of bomb_generator_8x8 is

    -- Interne Signale
    signal bomb_reg  : std_logic_vector(63 downto 0) := (others => '0'); -- Bombenfeld
    signal counter   : integer range 0 to 6 := 0;                        -- Anzahl aktuell gesetzter Bomben
    signal state     : std_logic := '0';                                 -- Zustand: '0' = inaktiv, '1' = generiert
    signal lfsr      : std_logic_vector(5 downto 0) := "101011";         -- LFSR für Zufallszahlen (6 Bit für 64 Werte)
    signal bomb_goal : integer range 2 to 6 := 3;                        -- Zielanzahl Bomben (zufällig zwischen 2–6)

begin

    -- Hauptprozess, der bei jedem Takt oder Reset reagiert
    process(clk, rst)
        -- temporäre Variable zur Position der Bombe
        variable pos : integer := 0;
    begin
        -- Asynchroner Reset: alle internen Werte zurücksetzen
        if rst = '1' then
            bomb_reg <= (others => '0');
            counter <= 0;
            state <= '0';
            done <= '0';
            lfsr <= "101011";
        
        -- Flankenerkennung auf steigende Taktflanke
        elsif rising_edge(clk) then
        
            -- Initialer Start: vorbereiten auf Generierung
            if start = '1' and state = '0' then
                bomb_reg <= (others => '0');                                -- Feld zurücksetzen
                counter <= 0;                                               -- Zähler zurücksetzen
                bomb_goal <= to_integer(unsigned(lfsr(2 downto 0))) mod 5 + 2; -- Zielanzahl Bomben: 2..6
                state <= '1';                                               -- Generator aktivieren
                done <= '0';                                                -- Noch nicht fertig

            -- Wenn aktiv: Bomben setzen, bis bomb_goal erreicht ist
            elsif state = '1' then
                -- LFSR weiterdrehen (6-Bit Galois-Zähler)
                lfsr <= lfsr(4 downto 0) & (lfsr(5) xor lfsr(4));

                -- Position im Bereich 0..63 berechnen
                pos := to_integer(unsigned(lfsr)) mod 64;

                -- Wenn Position noch nicht belegt → Bombe setzen
                if bomb_reg(pos) = '0' then
                    bomb_reg(pos) <= '1';
                    counter <= counter + 1;
                end if;

                -- Wenn Zielanzahl erreicht → Generator abschalten
                if counter = bomb_goal then
                    state <= '0';
                    done <= '1'; -- ein Takt lang aktiv
                end if;
            end if;
        end if;
    end process;

    -- Ausgangssignal zuweisen
    bombs <= bomb_reg;

end behavioral;
