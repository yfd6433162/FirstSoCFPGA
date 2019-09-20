create_clock -name "pclk" -period 40.000 [get_ports {GPIO_0[31]}] -waveform {0.000 20.000}
create_clock -name "fpga_clk" -period 20.000 [get_ports {FPGA_CLK1_50}] -waveform {0.000 10.000}

derive_pll_clocks -create_base_clocks

derive_clock_uncertainty

#set_false_path -from [get_ports HPS_I2C0_SCLK]
#set_false_path -from [get_ports HPS_I2C1_SCLK]
#set_false_path -from [get_ports HPS_USB_CLKOUT]
