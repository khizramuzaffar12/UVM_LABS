//----------------------------------------
//    AXI4-Lite Master Agent
//----------------------------------------
class master_agent extends uvm_agent;

  // Separate sequencers
  master_seqr write_sqr;
  master_seqr read_sqr;

  master_driver  drv;
  master_monitor mon;

  virtual dut_if vif;

  `uvm_component_utils(master_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    write_sqr = master_seqr ::type_id::create("write_sqr", this);
    read_sqr  = master_seqr ::type_id::create("read_sqr",  this);
    drv       = master_driver::type_id::create("drv",       this);
    mon       = master_monitor::type_id::create("mon",       this);

    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("AGENT", "Virtual interface not found")

    uvm_config_db#(virtual dut_if)::set(this, "write_sqr", "vif", vif);
    uvm_config_db#(virtual dut_if)::set(this, "read_sqr",  "vif", vif);
    uvm_config_db#(virtual dut_if)::set(this, "drv",       "vif", vif);
    uvm_config_db#(virtual dut_if)::set(this, "mon",       "vif", vif);
  endfunction

  //--------------------------------------------------
  // Connect Phase
  //--------------------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect write path
    drv.write_item_port.connect(write_sqr.seq_item_export);

    // Connect read path
    drv.read_item_port.connect(read_sqr.seq_item_export);

    `uvm_info("AGENT",
      "Connected WRITE & READ sequencers to driver",
      UVM_LOW)
  endfunction

endclass : master_agent
