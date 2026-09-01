`ifndef BUS_ENV_SV
`define BUS_ENV_SV

class bus_env extends uvm_env;
    int num_agents = 1; // default to 1
    bus_agent agents[]; // dynamic array of agents.
    bus_scoreboard scoreboard;

    // register the component in the factory and the num_agents as a UVM_field
    `uvm_component_utils_begin(bus_env)
    `uvm_field_int(num_agents, UVM_ALL_ON) // UVM_ALL_ON: Enable all applicable UVM field automation operations for num_agents
    `uvm_component_utils_end

    function new (string name = "bus_env", uvm_component parent);
        super.new (name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(num_agents <= 0) begin
            `uvm_fatal("NONUM", {"'num_agents' must be set"})
        end
        agents = new[num_agents]; // allocate the array
        for(int i = 0; i < num_agents; i++) begin
            string inst_name;
            $sformat(inst_name, "agents[%0d]", i);
            agents[i] = bus_agent::type_id::create(inst_name, this);
        end
        scoreboard = bus_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect each monitor's analysis port to the scoreboard FIFO.
        // All monitored transactions are therefore published to the scoreboard for checking.
        for(int i = 0; i < num_agents; i++) begin
            agents[i].b_mon.analysis_port.connect(scoreboard.fifo.analysis_export); // connect all the agents to the fifo.
        end
    endfunction


endclass


`endif 