module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ahb_pkg::*; // import your package with all classes

  ahb_lite_bus_if vif();
  ahb_slave_mem   dut(vif);

  initial begin
    vif.HCLK = 0;
    forever #5 vif.HCLK = ~vif.HCLK;
  end

  
  initial begin
    uvm_config_db#(virtual ahb_lite_bus_if)::set(null,"*","vif",vif);

    // Choose your test here:
    //run_test("write_read_test");        // 1) single write-read
    run_test("multi_write_read_test");  // 2) multiple write-read
    //run_test("random_rw_test");         // 3) random read/write
  end
endmodule

