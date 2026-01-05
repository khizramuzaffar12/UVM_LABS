-timescale=1ns/1ps
// ================= RTL =================
+incdir+rtl
rtl/ahb_lite_if.sv
rtl/ahb_dummy_master.sv

// ================= UVM TB =================
+incdir+tb
tb/ahb_slave_txn.sv
tb/ahb_slave_driver.sv
tb/ahb_slave_monitor.sv
tb/ahb_slave_scoreboard.sv
tb/ahb_slave_agent.sv
tb/ahb_slave_env.sv
tb/ahb_tests.sv
tb/top.sv
