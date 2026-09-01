`ifndef BUS_SCOREBOARD_SV
`define BUS_SCOREBOARD_SV

class bus_scoreboard extends uvm_scoreboard;
    // register in the factory
    `uvm_component_utils(bus_scoreboard)

    // The FIFO receives transactions published by the monitor's analysis_port.
    // The monitor writes transactions into the FIFO using:
    //     analysis_port.write(tx);
    // The scoreboard then retrieves those transactions from the FIFO using:
    //     fifo.get(tx);
    // Example connection in the environment:
    //     agents[0].b_mon.analysis_port.connect(scoreboard.fifo.analysis_export);
    // So the complete flow is:
    //     DUT
    //      |
    //      v
    //   Monitor
    //      |
    //      | analysis_port.write(tx)
    //      v
    //   analysis_fifo
    //      |
    //      | fifo.get(tx)
    //      v
    //   Scoreboard
    uvm_tlm_analysis_fifo#(bus_seq_item) fifo;

    function new(string name = "bus_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        fifo = new("fifo", this);
    endfunction

    extern task run_phase(uvm_phase phase);
endclass

task bus_scoreboard::run_phase(uvm_phase phase);
    // Scoreboard logic is written here.
    bus_seq_item tx;
    bus_seq_item tx_cp;
    forever begin
        fifo.get(tx);   

        tx_cp = bus_seq_item::type_id::create("tx_cp");
        tx_cp.copy(tx);
        // Check the transaction here.
    end
endtask

`endif 