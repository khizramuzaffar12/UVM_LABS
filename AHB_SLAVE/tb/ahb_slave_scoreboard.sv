class ahb_slave_scoreboard extends uvm_component;
  `uvm_component_utils(ahb_slave_scoreboard)

  uvm_analysis_imp #(ahb_slave_txn, ahb_slave_scoreboard) imp;
  //refernce memory
  bit [31:0] ref_mem [0:255];
  function new(string name, uvm_component parent);
    super.new(name,parent);
    imp = new("imp",this);
  endfunction

  function void write(ahb_slave_txn tr);

    // -----------------------------
    // Display received transaction
    // -----------------------------
    if (tr.write) begin
      `uvm_info(
        "SCOREBOARD",
        $sformatf(
          "WRITE txn received : ADDR=0x%08h DATA=0x%08h",
          tr.addr, tr.wdata
        ),
        UVM_MEDIUM
      )

      ref_mem[tr.addr[9:2]] = tr.wdata;
    end
    else begin
      `uvm_info(
        "SCOREBOARD",
        $sformatf(
          "READ txn received  : ADDR=0x%08h DATA=0x%08h EXP=0x%08h",
          tr.addr, tr.rdata, ref_mem[tr.addr[9:2]]
        ),
        UVM_MEDIUM
      )

      if (tr.rdata !== ref_mem[tr.addr[9:2]])
        `uvm_error(
          "READ_FAIL",
          $sformatf(
            "Read mismatch at ADDR=0x%08h : EXP=0x%08h ACT=0x%08h",
            tr.addr, ref_mem[tr.addr[9:2]], tr.rdata
          )
        )
    end

  endfunction
endclass
