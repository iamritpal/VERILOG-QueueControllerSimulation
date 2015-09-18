library verilog;
use verilog.vl_types.all;
entity framer is
    generic(
        N               : integer := 8;
        AB              : integer := 171
    );
    port(
        ser_in          : in     vl_logic;
        ser_clk         : in     vl_logic;
        reset_n         : in     vl_logic;
        clk_div_4       : out    vl_logic;
        clk_div_8       : out    vl_logic;
        par_out         : out    vl_logic_vector(7 downto 0);
        decode_AB       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of AB : constant is 1;
end framer;
