//------------------------------------------------------------------------------
// AHB-Lite Slave Transaction
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_trans extends uvm_sequence_item;

  `uvm_object_utils(ahb_lite_slave_trans)

  function new(string name="ahb_lite_slave_trans");
    super.new(name);
  endfunction

endclass

