module ahb_dummy_master (ahb_lite_bus_if ahb_if);

  task ahb_write(input [31:0] addr, input [31:0] data);
    @(posedge ahb_if.HCLK);
    ahb_if.HTRANS <= 2'b10;   // NONSEQ
    ahb_if.HWRITE <= 1'b1;
    ahb_if.HADDR  <= addr;
    ahb_if.HWDATA <= data;

    wait(ahb_if.HREADYOUT);
    @(posedge ahb_if.HCLK);
    ahb_if.HTRANS <= 2'b00;   // IDLE
  endtask

  task ahb_read(input [31:0] addr);
    @(posedge ahb_if.HCLK);
    ahb_if.HTRANS <= 2'b10;
    ahb_if.HWRITE <= 1'b0;
    ahb_if.HADDR  <= addr;

    wait(ahb_if.HREADYOUT);
    @(posedge ahb_if.HCLK);
    ahb_if.HTRANS <= 2'b00;
  endtask

endmodule

