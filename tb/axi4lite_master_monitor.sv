//----------------------------------------
//    Monitor of AXI4-Lite
//----------------------------------------
class master_monitor extends uvm_monitor;
  `uvm_component_utils(master_monitor)
  virtual dut_if vif;
  uvm_analysis_port #(axi4lite_seq) mon_ap;
  axi4lite_seq tr_mon;
  
  bit w_done, r_done;
  
  function new(string name="master_monitor", uvm_component parent);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
    w_done = 1;
    r_done = 1;
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
     end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //`uvm_info("MONITOR_CLASS", "Run phase!", UVM_LOW)

    forever  begin 
      // Wait for a SETUP cycle
//       repeat(6) begin
//         @ (this.vif.monitor_cb);
//       end
      //`uvm_info("MONITOR_CLASS", "Within forever loop!", UVM_LOW)  
      
      tr_mon = axi4lite_seq::type_id::create("tr_mon");
      //`uvm_info("MONITOR_CLASS", "Transaction created!", UVM_LOW)
      @ (this.vif.monitor_cb);
      tr_mon.AWVALID = this.vif.monitor_cb.AWVALID;
      tr_mon.WVALID  = this.vif.monitor_cb.WVALID;
      tr_mon.ARVALID = this.vif.monitor_cb.ARVALID;
      tr_mon.RVALID  = this.vif.monitor_cb.RVALID;
      //@ (this.vif.monitor_cb);
      tr_mon.BVALID  = this.vif.monitor_cb.BVALID;
      //uvm_report_info("AXI4lite_MONITOR ", $psprintf("AWVALID=%d   WVALID=%d    ARVALID=%d    RVALID=%d  BVALID=%d" ,tr_mon.AWVALID, tr_mon.WVALID, tr_mon.ARVALID, tr_mon.RVALID, tr_mon.BVALID));
       //$display("AWVALID=%d   WVALID=%d    ARVALID=%d    RVALID=%d  BVALID=%d" ,tr_mon.AWVALID, tr_mon.WVALID, tr_mon.ARVALID, tr_mon.RVALID, tr_mon.BVALID);

//       while (tr_mon.AWVALID!==1'b1 && this.vif.monitor_cb.WVALID!==1'b1*/ || tr_mon.ARVALID!==1'b1 /*&& this.vif.monitor_cb.RVALID!==1'b1); 
      
      if(tr_mon.AWVALID==1 && tr_mon.WVALID==1)  begin
        //`uvm_info("MONITOR_CLASS", "Within write check statemnet!", UVM_LOW)
        tr_mon.AWADDR = this.vif.monitor_cb.AWADDR;
        tr_mon.WDATA  = this.vif.monitor_cb.WDATA;
        tr_mon.WSTRB = this.vif.monitor_cb.WSTRB;
        uvm_report_info("AXI4lite_MONITOR", $psprintf("Got Transaction %s",tr_mon.wr_convert2string()));
      end
      
 //     uvm_info("MONITOR_CLASS", "Before read check statemnet!", UVM_LOW)
      else if(tr_mon.ARVALID)  begin
        //`uvm_info("MONITOR_CLASS", "Within read check statemnet!", UVM_LOW)
        tr_mon.ARADDR = this.vif.monitor_cb.ARADDR;
        tr_mon.RDATA  = this.vif.monitor_cb.RDATA;
        uvm_report_info("AXI4lite_MONITOR", $psprintf("Got Transaction %s",tr_mon.rd_convert2string()));
      end
      
      
      //tr_mon.BRESP = vif.monitor_cb.BRESP;

      mon_ap.write(tr_mon);
      wait(vif.monitor_cb.BVALID | vif.monitor_cb.RVALID);
      //$display("Data writen from monitor into analysis port");
    end      // forever loop end 
  endtask
endclass

