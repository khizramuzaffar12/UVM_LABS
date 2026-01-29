//----------------------------------------------------------
//   AXI4-Lite READ Sequence (Randomized)
//----------------------------------------------------------
class read_sequence extends uvm_sequence #(axi4lite_seq);
  `uvm_object_utils(read_sequence)

  function new(string name="read_sequence");
    super.new(name);
  endfunction

  task body();
    axi4lite_seq tr;

    //repeat (5) begin
      tr = axi4lite_seq::type_id::create("tr");

      start_item(tr);

      // Randomize READ transaction only
      assert(tr.randomize() with {
        ARVALID == 1;
        RREADY  == 1;
        AWVALID == 0;
        WVALID  == 0;
        WSTRB   == 0;
      });

      finish_item(tr);

      `uvm_info("READ_SEQ",
        $psprintf("READ TX: %s", tr.rd_convert2string()),
        UVM_LOW)
   // end
  endtask
endclass
//----------------------------------------------------------
//   AXI4-Lite WRITE Sequence (Randomized)
//----------------------------------------------------------
class write_sequence extends uvm_sequence #(axi4lite_seq);
  `uvm_object_utils(write_sequence)

  function new(string name="write_sequence");
    super.new(name);
  endfunction

  task body();
    axi4lite_seq tr;

    //repeat (5) begin
      tr = axi4lite_seq::type_id::create("tr");

      start_item(tr);

      // Randomize WRITE transaction only
      assert(tr.randomize() with {
        AWVALID == 1;
        WVALID  == 1;
        ARVALID == 0;
        RREADY  == 0;
        WSTRB   == 4'hF;
      });

      finish_item(tr);

      `uvm_info("WRITE_SEQ",
        $psprintf("WRITE TX: %s", tr.wr_convert2string()),
        UVM_LOW)
   // end
  endtask
endclass

