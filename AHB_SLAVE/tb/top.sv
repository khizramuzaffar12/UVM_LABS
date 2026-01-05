module top;
  import uvm_pkg::*;


  ahb_lite_bus_if ahb_if();
  ahb_dummy_master master(ahb_if);

  initial begin
    ahb_if.HCLK = 0;
    forever #5 ahb_if.HCLK = ~ahb_if.HCLK;
  end

  initial begin
    uvm_config_db#(virtual ahb_lite_bus_if)::set(null,"*","vif",ahb_if);
    run_test("ahb_multi_write_read_test");
  end
endmodule

