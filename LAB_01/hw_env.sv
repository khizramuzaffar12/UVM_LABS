import uvm_pkg::*;

//------------------------------------------------------------------------------
// Environment class
// This class represents the top-level UVM environment
//------------------------------------------------------------------------------

class hw_env extends uvm_env;

  // Factory registration
  `uvm_component_utils(hw_env)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  // Used to construct sub-components
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  // Run phase
  // Keeps simulation alive for a fixed amount of time
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Dummy delay to keep simulation running
    #500;

    phase.drop_objection(this);
  endtask

endclass

