
yosys read_verilog computer.v
yosys read_verilog alu.v
yosys read_verilog pc.v
yosys read_verilog register.v
yosys read_verilog instruction_memory.v
yosys read_verilog data_memory.v
yosys read_verilog control_unit.v
yosys read_verilog muxA.v
yosys read_verilog muxB.v
yosys read_verilog muxData.v
yosys read_verilog muxWB.v
yosys read_verilog status.v

yosys synth
yosys write_verilog out/netlist.v

yosys stat
yosys tee -q -o "out/computer.rpt" stat
