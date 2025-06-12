## Clock
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Buttons
set_property PACKAGE_PIN D9  [get_ports btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports btn_up]

set_property PACKAGE_PIN C10 [get_ports btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports btn_down]

set_property PACKAGE_PIN D10 [get_ports btn_left]
set_property IOSTANDARD LVCMOS33 [get_ports btn_left]

set_property PACKAGE_PIN A8 [get_ports btn_right]
set_property IOSTANDARD LVCMOS33 [get_ports btn_right]

set_property PACKAGE_PIN C8 [get_ports btn_act]
set_property IOSTANDARD LVCMOS33 [get_ports btn_act]

## VGA Red (vga_r[3:0])
set_property PACKAGE_PIN A3 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]
set_property PACKAGE_PIN B4 [get_ports {vga_r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN C5 [get_ports {vga_r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN A4 [get_ports {vga_r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]

## VGA Green (vga_g[3:0])
set_property PACKAGE_PIN C6 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]
set_property PACKAGE_PIN A5 [get_ports {vga_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN B6 [get_ports {vga_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN A6 [get_ports {vga_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]

## VGA Blue (vga_b[3:0])
set_property PACKAGE_PIN C7 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]
set_property PACKAGE_PIN B7 [get_ports {vga_b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN D7 [get_ports {vga_b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN D8 [get_ports {vga_b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]

## VGA Syncs
set_property PACKAGE_PIN B11 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

set_property PACKAGE_PIN B12 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
