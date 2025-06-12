----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.06.2025 12:06:56
-- Design Name: 
-- Module Name: display_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_tb is
end display_tb;

architecture Behavioral of display_tb is

    component display is
        port (
        clk     : in  std_logic; -- 25 MHz VGA-Takt
        vga_r   : out std_logic_vector(3 downto 0);
        vga_g   : out std_logic_vector(3 downto 0);
        vga_b   : out std_logic_vector(3 downto 0);
        hsync   : out std_logic;
        vsync   : out std_logic
        );
    end component;
    
  -- input
  signal clk   : std_logic := '0';

  -- output
  signal vga_r, vga_g, vga_b    : std_logic_vector(3 downto 0);
  signal hsync, vsync           : std_logic;
  
begin

    clk <= not clk after 20ns;

dut : display
    port map(
        clk     =>  clk,
        vga_r   =>  vga_r,
        vga_g   =>  vga_g,
        vga_b   =>  vga_b,
        hsync   =>  hsync,
        vsync   =>  vsync
        );
end Behavioral;
