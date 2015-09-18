library verilog;
use verilog.vl_types.all;
entity QueueController is
    generic(
        max_size        : integer := 7;
        NMB_QUES        : integer := 4
    );
    port(
        clk_div_8       : in     vl_logic;
        reset_n         : in     vl_logic;
        par_out         : in     vl_logic_vector(7 downto 0);
        decode_AB       : in     vl_logic;
        data_out        : out    vl_logic_vector(63 downto 0);
        valid_data_out  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of max_size : constant is 1;
    attribute mti_svvh_generic_type of NMB_QUES : constant is 1;
end QueueController;
