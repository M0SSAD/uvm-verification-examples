`ifndef BUS_SEQUENCER_SV
`define BUS_SEQUENCER_SV

class bus_sequencer extends uvm_sequencer #(bus_seq_item);

    // factory registeration
    `uvm_component_utils(bus_sequencer)

    // constructor
    function new(string name = "bus_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

    // the uvm sequencer is enough for this example, no need to implement anything else.
endclass

`endif