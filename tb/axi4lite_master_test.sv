//------------------------------------------------------------
//  AXI4-Lite Parallel Read/Write Test (NO virtual seqr)
//------------------------------------------------------------
class axi_parallel_rw_test extends uvm_test;

  `uvm_component_utils(axi_parallel_rw_test)

  my_env env;
  virtual dut_if vif;

  function new(string name="axi_parallel_rw_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = my_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Virtual interface not found")

    uvm_config_db#(virtual dut_if)::set(this, "env", "vif", vif);
  endfunction

  //--------------------------------------------------
  // Run Phase
  //--------------------------------------------------
  task run_phase(uvm_phase phase);
    write_sequence wr_seq;
    read_sequence  rd_seq;

    wr_seq = write_sequence::type_id::create("wr_seq");
    rd_seq = read_sequence ::type_id::create("rd_seq");

    phase.raise_objection(this);
    `uvm_info(get_type_name(),
              "Starting parallel READ & WRITE sequences",
              UVM_LOW)

    fork
      wr_seq.start(env.agt.write_sqr);
      rd_seq.start(env.agt.read_sqr);
    join

    phase.drop_objection(this);
  endtask

endclass
