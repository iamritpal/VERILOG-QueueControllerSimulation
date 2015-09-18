library verilog;
use verilog.vl_types.all;
entity tb_gen is
    port(
        ser_in          : out    vl_logic;
        ser_clk         : out    vl_logic;
        reset_n         : out    vl_logic
    );
end tb_gen;
