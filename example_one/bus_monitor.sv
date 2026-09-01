`ifndef BUS_MONITOR_SV
`define BUS_MONITOR_SV

class bus_monitor extends uvm_monitor;
    `uvm_component_utils(bus_monitor)

    virtual dut_if vif; // interface to interact with the dut.
    bus_seq_item tx; // handle for the transaction.

    uvm_analysis_port #(bus_seq_item) analysis_port;

    function new (string name = "bus_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual dut_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    extern task run_phase (uvm_phase phase); // declare the function, defined somewhere else.
endclass

task bus_monitor::run_phase(uvm_phase phase);
    // monitor logic is written here.
    
    forever begin
        // observe the DUT (we don't have one for this example, just building the env.)

        // fill transactions
        tx = bus_seq_item::type_id::create("tx"); // create a different transaction for each dut cycle.
        tx.addr = 'd17;

        // send to the analysis components
        analysis_port.write(tx);

    end
endtask

`endif 