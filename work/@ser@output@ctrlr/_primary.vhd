library verilog;
use verilog.vl_types.all;
entity SerOutputCtrlr is
    port(
        clk_div_4       : in     vl_logic;
        reset_n         : in     vl_logic;
        data_out        : in     vl_logic_vector(63 downto 0);
        valid_data_out  : in     vl_logic;
        ser_out         : out    vl_logic
    );
end SerOutputCtrlr;
