
import axi4lite_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
           

module tb_top;
logic ACLK; 
logic rstn;
  
  dut_if t_vif (ACLK);
  
  axi_lite_slave dut(.s_axi_lite(t_vif));
  
  initial  begin 
    ACLK = 1; 
  end
  
  always #5 ACLK = ~ACLK;
  
  initial  begin
    t_vif.ARESETN = 0;
    @(posedge t_vif.ACLK);
    t_vif.ARESETN = 1;
  end
  
  initial  begin
    uvm_config_db#(virtual dut_if)::set( null, "uvm_test_top", "vif", t_vif);
    run_test("axi_parallel_rw_test");
    
  end
  
  
  initial  begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
  
endmodule
