//--------------------------------------
// 1) Single write-read test
//--------------------------------------
class write_read_test extends uvm_test;
  `uvm_component_utils(write_read_test)

  ahb_env env;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);   // call UVM base class
    env = ahb_env::type_id::create("env", this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    write_read_same_addr_seq seq;
    phase.raise_objection(this);

    // Create and start sequence
    seq = write_read_same_addr_seq::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);
  endtask
endclass

//--------------------------------------
// 2) Multiple write-read test
//--------------------------------------
class multi_write_read_test extends uvm_test;
  `uvm_component_utils(multi_write_read_test)

  ahb_env env;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    multi_write_read_seq seq;
    phase.raise_objection(this);

    // Create and start sequence
    seq = multi_write_read_seq::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);
  endtask
endclass

//--------------------------------------
// 3) Random read/write test
//--------------------------------------
class random_rw_test extends uvm_test;
  `uvm_component_utils(random_rw_test)

  ahb_env env;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    random_rw_seq seq;
    phase.raise_objection(this);

    // Create and start sequence
    seq = random_rw_seq::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);
  endtask
endclass

