import uvm_pkg::*;

//------------------------------------------------------------------------------
// Test class
// This is the top-level test that creates the environment
//------------------------------------------------------------------------------

class hw_test extends uvm_test;

  // Factory registration
  `uvm_component_utils(hw_test)

  // Environment handle
  hw_env env;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  // Create environment using factory
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = hw_env::type_id::create("env", this);
  endfunction

  // Run phase
  // Prints a simple message (Hello World)
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("HW_TEST", "Hello World from hw_test", UVM_LOW)
    phase.drop_objection(this);
  endtask


endclass

