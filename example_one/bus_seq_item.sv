`ifndef BUS_SEQ_ITEM_SV
`define BUS_SEQ_ITEM_SV 

// sequence item for simple read/write interface.
class bus_seq_item extends uvm_sequence_item;
  // sequence item fields
  // request -> randomized.
  rand logic [31:0] addr;
  rand logic [31:0] write_data;
  rand bit read_not_write;
  rand int delay;

  // response -> not randomized
  bit error;
  logic [31:0] read_data;

  `uvm_object_utils(bus_seq_item)  // register the class in the factory

  function new(string name = "bus_seq_item");  // deffered constructor
    super.new(name);
  endfunction

  // constraints on randomized fields
  constraint at_least_1 {
    delay inside {[1 : 20]};  // delay must be constrained between 1 to 20 cycles.
  }

  constraint align_32 {
    addr[1:0] == 'd0;  // address must be of aligned 4 bytes.
  }


  // Further constraints could be added by inheriting from this class and adding specified constraints on the sequence item
  // based on the scenario.


endclass
`endif
