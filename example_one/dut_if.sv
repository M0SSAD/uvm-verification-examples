interface dut_if (input clk);
    logic [31:0] addr;
    logic [31:0] write_data;
    bit read_not_write;
    int delay;
    bit error;
    logic [31:0] read_data;
endinterface