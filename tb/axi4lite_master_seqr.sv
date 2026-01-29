//----------------------------------------
//    Sequencer of AXI4-Lite
//----------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;
class master_seqr extends uvm_sequencer#(axi4lite_seq);
  
    `uvm_component_utils(master_seqr)
    
    function new ( string name, uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
    endfunction
    
endclass : master_seqr
