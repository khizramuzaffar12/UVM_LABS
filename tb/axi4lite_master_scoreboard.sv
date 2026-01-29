//----------------------------------------
//    Scoreboard of AXI4-Lite
//----------------------------------------
class master_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(master_scoreboard)
  uvm_analysis_imp#(axi4lite_seq, master_scoreboard) mon_export;
  
  axi4lite_seq test_que[$];
  bit [31:0] test_mem[0:134217727];  // 27 bit limitation in Compiler
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_export = new ("mon_export", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach (test_mem[i])  test_mem[i] = i;
  endfunction
  
  function void write(axi4lite_seq tr);
    test_que.push_back(tr);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    axi4lite_seq exp_data;
    
    //`uvm_info("SCOREBOARD CLASS","Within Scoreboard run phase",UVM_LOW)
    forever  begin
      
      wait(test_que.size()>0);
      exp_data = test_que.pop_front();
      //$display("Within Scoreboard Queue is POPPED");
      
      if(exp_data.AWVALID == 1 && exp_data.WVALID==1)  begin
        `uvm_info("SCOREBOARD_CLASS",$sformatf("------ :: WRITE DATA MATCH  :: ------"),UVM_LOW)
        `uvm_info("",$sformatf("Write Addr: %0h",exp_data.AWADDR),UVM_LOW)
        `uvm_info("",$sformatf("Write Data: %0h",exp_data.WDATA),UVM_LOW)
        end

      if (exp_data.ARVALID==1 && exp_data.RVALID==1)  begin
        if(test_mem[exp_data.ARADDR] == exp_data.RDATA) begin
          `uvm_info("SCOREBOARD_CLASS",$sformatf("------ :: READ DATA MATCH :: ------"),UVM_LOW)
          `uvm_info("",$sformatf("Read Addr: %0h",exp_data.ARADDR),UVM_LOW)
          `uvm_info("",$sformatf("Expected Read Data: %0h Actual Read Data: %0h",test_mem[exp_data.ARADDR],exp_data.RDATA),UVM_LOW)
        end
        else begin
          `uvm_info("SCOREBOARD_CLASS",$sformatf("------ :: READ DATA MISMATCH  :: ------"),UVM_LOW)
          `uvm_info("",$sformatf("Read Addr: %0h",exp_data.ARADDR),UVM_LOW)
          `uvm_info("",$sformatf("Expected Read Data: %0h Actual Read Data: %0h",test_mem[exp_data.ARADDR],exp_data.RDATA),UVM_LOW)
        end
      end
        
    end // Forever loop end
  endtask
  
endclass

