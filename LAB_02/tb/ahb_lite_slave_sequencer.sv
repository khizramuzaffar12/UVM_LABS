//------------------------------------------------------------------------------
// AHB-Lite Slave Sequencer
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_lite_slave_sequencer extends uvm_sequencer #(ahb_lite_slave_trans);

  `uvm_component_utils(ahb_lite_slave_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

