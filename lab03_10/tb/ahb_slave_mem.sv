module ahb_slave_mem (ahb_lite_bus_if vif);

  logic [31:0] mem [0:255];

  always @(posedge vif.HCLK) begin
    if (!vif.HRESETn) begin
      vif.HREADYOUT <= 1'b0;
      vif.HRESP     <= 2'b00;
      vif.HRDATA    <= 32'b0;
    end
    else if (vif.HTRANS == 2'b10) begin  // NONSEQ
      vif.HREADYOUT <= 1'b0;
      $display("inside ahb_slave_mem");
      if (vif.HWRITE) begin
        mem[vif.HADDR[9:2]] <= vif.HWDATA;
        vif.HREADYOUT <= 1'b1;
      end    
      else begin
        vif.HRDATA <= mem[vif.HADDR[9:2]];
        vif.HREADYOUT <= 1'b1;
      end   
    end
    else begin
    vif.HREADYOUT <= 1'b0;
    end
  end
endmodule
//

