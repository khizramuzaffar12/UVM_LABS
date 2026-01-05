//------------------------------------------------------------------------------
// Top Module
//------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"

module top;

  ahb_lite_bus_if vif();

  initial begin
    run_test("ahb_lite_slave_test");
  end

endmodule

