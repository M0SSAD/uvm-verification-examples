`ifndef BUS_DRIVER_SV
`define BUS_DRIVER_SV 

class bus_driver extends uvm_driver #(bus_seq_item); // response will get the same type as request (bus_seq_item).
  bus_seq_item   drv_tx;  // sequence item that we will receive from the sequencer
  virtual dut_if vif;  // interface to interact with the dut pins.

  `uvm_component_utils(bus_driver)  // Register in the factory.

  // constructor
  function new(string name = "bus_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // get the interface from the db.
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"
                 });  // if the interface wasn't found, output an error.
    end
  endfunction

  // run phase
  task run_phase(uvm_phase phase);
    forever begin
      // TLM port to get TXs. (seq_item_port is already provided by uvm_driver.)
      seq_item_port.get_next_item(drv_tx);  // blocks until an item is put by the sequencer
      // could use try_next_item, it won't block the execution if no transactions were found.

      fork  // drive the signals using another thread, done this way for the pipelined protocols.
        begin
          drive_and_respond(drv_tx);
        end
      join_none

      seq_item_port.item_done(); // The request has been consumed from the driver's perspective, (delegated it to another thread.)
    end
  endtask

  // actual protocol logic is done here.
  task drive_and_respond(bus_seq_item tx);
    // Drive DUT signals here.

    // driver can return response to sequncer using seq_item_port.put_response(respones);, but the sequencer must have seq_item_port.get_response();, because it is blocking.
    // we give the res the same id as the tx using response.set_id_info(tx);

    // there are many ways to respond:
    // 1. modify the tx object if it was passed by reference,
    // 2. create a response object and pass it using the put_response method.
    // etc...

    // Example for the logic
    /**
        bus_seq_item rsp;

        // 1. Drive request to DUT
        drive(req);

        // 2. Wait for DUT response
        wait_for_response();

        // 3. Create response
        rsp = bus_seq_item::type_id::create("rsp");

        rsp.read_data = vif.read_data;
        rsp.error     = vif.error;

        // Associate response with request
        rsp.set_id_info(req);

        // 4. Send response back to sequencer
        seq_item_port.put_response(rsp);
    */
  endtask

endclass


`endif
