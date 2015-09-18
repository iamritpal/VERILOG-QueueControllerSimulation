library verilog;
use verilog.vl_types.all;
entity chip is
    port(
        ser_clk         : in     vl_logic;
        ser_in          : in     vl_logic;
        reset_n         : in     vl_logic;
        ser_out         : out    vl_logic;
        clk_div_4       : out    vl_logic
    );
end chip;
