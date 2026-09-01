`ifndef BUS_AGENT_SV
`define BUS_AGENT_SV

class bus_agent extends uvm_agent;

    // register the agent as a component
    `uvm_component_utils(bus_agent)

    // handle for sequencer
    bus_sequencer b_seq;
    // handle for driver
    bus_driver b_drv;
    // handle for monitor
    bus_monitor b_mon;

    function new(string name = "bus_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        // create the instances of the components.
        b_mon = bus_monitor::type_id::create("monitor", this);
        // the agent is avtive by default, but it can be configured as a passive agent in the test/environment.
        if(is_active == UVM_ACTIVE) begin // is_active is already declared inside uvm_agent
            b_seq = bus_sequencer::type_id::create("sequencer", this);
            b_drv = bus_driver::type_id::create("driver", this);    
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(is_active == UVM_ACTIVE) begin 
            // connect the driver get port to the sequencer.
            b_drv.seq_item_port.connect(b_seq.seq_item_export); 
        end
    endfunction
endclass


`endif 