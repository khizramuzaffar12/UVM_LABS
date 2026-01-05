//--------------------------------------
// 1) Single Write then Read SAME Address
//--------------------------------------
class write_read_same_addr_seq extends uvm_sequence #(ahb_txn);
  `uvm_object_utils(write_read_same_addr_seq)

  task body();
    ahb_txn tr;
    bit [31:0] addr = 32'h10;
    bit [31:0] data = 32'hDEAD_BEEF;

    // WRITE
    tr = ahb_txn::type_id::create("wr_tr");
    tr.write = 1;
    tr.addr  = addr;
    tr.data  = data;
    `uvm_info("SEQ",$sformatf("WRITE : %s", tr.sprint()),UVM_MEDIUM)
    start_item(tr); finish_item(tr);

    // READ
    tr = ahb_txn::type_id::create("rd_tr");
    tr.write = 0;
    tr.addr  = addr;
    `uvm_info("SEQ",$sformatf("READ  : %s", tr.sprint()),UVM_MEDIUM)
    start_item(tr); finish_item(tr);
  endtask
endclass

//--------------------------------------
// 2) Multiple Writes then Reads
//--------------------------------------
class multi_write_read_seq extends uvm_sequence #(ahb_txn);
  `uvm_object_utils(multi_write_read_seq)

  task body();
    ahb_txn tr;

    for (int i = 0; i < 4; i++) begin
      // WRITE
      tr = ahb_txn::type_id::create($sformatf("wr_tr_%0d", i));
      tr.write = 1;
      tr.addr  = i * 4;
      tr.data  = 32'h1000 + i;
      `uvm_info("SEQ",$sformatf("WRITE : %s", tr.sprint()),UVM_MEDIUM)
      start_item(tr); finish_item(tr);

      // READ
      tr = ahb_txn::type_id::create($sformatf("rd_tr_%0d", i));
      tr.write = 0;
      tr.addr  = i * 4;
      `uvm_info("SEQ",$sformatf("READ  : %s", tr.sprint()),UVM_MEDIUM)
      start_item(tr); finish_item(tr);
    end
  endtask
endclass

//--------------------------------------
// 3) Random Read/Write Sequence
//--------------------------------------
class random_rw_seq extends uvm_sequence #(ahb_txn);
  `uvm_object_utils(random_rw_seq)

  task body();
    ahb_txn tr;

    for (int i = 0; i < 5; i++) begin
      tr = ahb_txn::type_id::create($sformatf("rand_tr_%0d", i));
      tr.write = $urandom_range(0, 1);
      tr.addr  = ($urandom_range(0, 255) * 4);
      tr.data  = $urandom;

      `uvm_info("SEQ",$sformatf("%s", tr.sprint()),UVM_MEDIUM)
      start_item(tr); finish_item(tr);
    end
  endtask
endclass

