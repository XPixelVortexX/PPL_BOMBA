library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity random_gen is
    port (
        clk      : in std_logic;
        bomb_map : out std_logic_vector(63 downto 0)
    );
end random_gen;

architecture behavioral of random_gen is
    signal lfsr     : std_logic_vector(5 downto 0) := "101011";
    signal bomb_reg : std_logic_vector(63 downto 0) := (others => '0');
    signal counter  : integer range 0 to 6 := 0;

begin

    process(clk)
        variable pos : integer := 0;
    begin
        if rising_edge(clk) then
            if counter < 5 then
                -- LFSR weiterdrehen (6 Bit Galois)
                lfsr <= lfsr(4 downto 0) & (lfsr(5) xor lfsr(4));

                pos := to_integer(unsigned(lfsr)) mod 64;

                if bomb_reg(pos) = '0' then
                    bomb_reg(pos) <= '1';
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    bomb_map <= bomb_reg;

end behavioral;

