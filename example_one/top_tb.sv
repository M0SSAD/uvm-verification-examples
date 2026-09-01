`ifndef TOP_TB_SV
`define TOP_TB_SV

import uvm_pkg::*;
import bus_package::*;
import uvm_package::*;
module top_tb ();
    bit clk;
    initial begin
        forever begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end
    end

    // instantiate the interfaces
    dut_if vif(clk);
    // instantiate the dut

    // uvm initial block
    initial begin
        // config_db 
        uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if", vif);
        // run tests
        run_test();
    end

endmodule
`endif 