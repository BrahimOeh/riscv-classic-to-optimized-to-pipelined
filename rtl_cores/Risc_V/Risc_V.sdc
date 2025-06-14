
# Clock constraints

create_clock -name "clk" -period 20.000ns [get_ports {clk}] -waveform {0.000 10.000}


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
#derive_clock_uncertainty
# Not supported for family Cyclone II

# tsu/th constraints

# tco constraints

# tpd constraints