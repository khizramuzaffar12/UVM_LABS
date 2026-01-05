//------------------------------------------------------------------------------
// AHB-Lite Slave Sequence
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_seq extends uvm_sequence #(ahb_lite_slave_trans);

  `uvm_object_utils(ahb_lite_slave_seq)

  function new(string name="ahb_lite_slave_seq");
    super.new(name);
  endfunction

  task body();
    // No stimulus generation in Lab-2
  endtask

endclass

