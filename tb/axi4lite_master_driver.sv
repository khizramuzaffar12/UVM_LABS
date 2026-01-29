//------------------------------------------------------------
//    AXI4-Lite Master Driver (CORRECTED)
//    - Parallel Read & Write
//    - UVM safe (no killed threads)
//------------------------------------------------------------
class master_driver extends uvm_driver #(axi4lite_seq);
  `uvm_component_utils(master_driver)

  virtual dut_if vif;

  uvm_seq_item_pull_port #(axi4lite_seq) write_item_port;
  uvm_seq_item_pull_port #(axi4lite_seq) read_item_port;

  axi4lite_seq write_tr_h;
  axi4lite_seq read_tr_h;

  function new(string name="master_driver", uvm_component parent);
    super.new(name, parent);
    write_item_port = new("write_item_port", this);
    read_item_port  = new("read_item_port",  this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Virtual interface not found")
  endfunction

  //------------------------------------------------------------
  // Run Phase
  //------------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    vif.m_driver_cb.BREADY <= 1'b1;
    vif.m_driver_cb.RREADY <= 1'b1;

    forever begin
      @(vif.m_driver_cb);

      if (!vif.ARESETN) begin
        vif.m_driver_cb.AWVALID <= 0;
        vif.m_driver_cb.WVALID  <= 0;
        vif.m_driver_cb.ARVALID <= 0;
      end
      else begin
        fork
          //-----------------------------------------
          // WRITE THREAD
          //-----------------------------------------
          begin
            write_item_port.get_next_item(write_tr_h);

            `uvm_info("AXI_DRV",
              $psprintf("WRITE Transaction:\n%s",
              write_tr_h.wr_convert2string()), UVM_MEDIUM)

            write_tr(write_tr_h);
            write_item_port.item_done();
          end

          //-----------------------------------------
          // READ THREAD
          //-----------------------------------------
          begin
            read_item_port.get_next_item(read_tr_h);

            `uvm_info("AXI_DRV",
              $psprintf("READ Transaction:\n%s",
              read_tr_h.rd_convert2string()), UVM_MEDIUM)

            read_tr(read_tr_h);
            read_item_port.item_done();
          end
        join
      end
    end
  endtask

  //------------------------------------------------------------
  // WRITE TRANSACTION
  //------------------------------------------------------------
  task write_tr(axi4lite_seq tr);
    @(vif.m_driver_cb);

    vif.m_driver_cb.AWADDR  <= tr.AWADDR;
    vif.m_driver_cb.WDATA   <= tr.WDATA;
    vif.m_driver_cb.WSTRB   <= tr.WSTRB;

    vif.m_driver_cb.AWVALID <= 1;
    vif.m_driver_cb.WVALID  <= 1;

    wait (vif.m_driver_cb.AWREADY);
    wait (vif.m_driver_cb.WREADY);

    vif.m_driver_cb.AWVALID <= 0;
    vif.m_driver_cb.WVALID  <= 0;

    wait (vif.m_driver_cb.BVALID);
  endtask

  //------------------------------------------------------------
  // READ TRANSACTION
  //------------------------------------------------------------
  task read_tr(axi4lite_seq tr);
    @(vif.m_driver_cb);

    vif.m_driver_cb.ARADDR  <= tr.ARADDR;
    vif.m_driver_cb.ARVALID <= 1;

    wait (vif.m_driver_cb.ARREADY);
    vif.m_driver_cb.ARVALID <= 0;

    wait (vif.m_driver_cb.RVALID);
  endtask

endclass

