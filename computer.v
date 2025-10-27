
module computer (
    input clk,
    output [7:0] alu_out_bus
);
  
  wire [7:0]  pc_out_bus;
  wire [14:0] im_out_bus;
  wire [7:0]  regA_out_bus;
  wire [7:0]  regB_out_bus;

  wire [6:0] opcode = im_out_bus[14:8];
  wire [7:0] K      = im_out_bus[7:0];

  wire LA, LB, LP, W, mem_we;
  wire [1:0] selA, selB, selData;  
  wire       wbSel;                
  wire [3:0] alu_op;
  
  wire Z, N, C, V;
  wire [3:0] status_out;

  wire [7:0] alu_a_bus;
  wire [7:0] alu_b_bus;

  pc PC (
      .clk(clk),
      .LP(LP),
      .K(K),
      .pc(pc_out_bus)
  );

  instruction_memory IM (
      .address(pc_out_bus),
      .out(im_out_bus)
  );

  control CU (
    .opcode(opcode),
    .status(status_out),
    .LA(LA),
    .LB(LB),
    .LP(LP),
    .mem_we(mem_we),   
    .wbSel(wbSel),     
    .selA(selA),
    .selB(selB),
    .selData(selData), 
    .alu_op(alu_op)
  );

  wire [7:0] dmem_addr;
  wire [7:0] dmem_out;

  muxData MUXD (
    .A(regA_out_bus),
    .B(regB_out_bus),
    .K(K),
    .PC(pc_out_bus),   
    .sel(selData),
    .out(dmem_addr)
  );

  data_memory DM (
    .clk(clk),
    .address(dmem_addr),
    .data_in(alu_out_bus),
    .W(mem_we),
    .data_out(dmem_out)
  );

  wire [7:0] wb_data;
  muxWB muxWB (
      .alu_out(alu_out_bus),
      .mem_out(dmem_out),
      .sel(wbSel),
      .out(wb_data)
  );

  register regA (
      .clk (clk),
      .data(wb_data),
      .load(LA),
      .out (regA_out_bus)
  );

  register regB (
      .clk (clk),
      .data(wb_data),
      .load(LB),
      .out (regB_out_bus)
  );

  muxA muxA (
      .A  (regA_out_bus),
      .B  (regB_out_bus),
      .K_unused(8'h00),
      .mem_data(dmem_out),
      .sel(selA),
      .out(alu_a_bus)
  );

  muxB muxB (
      .A  (regA_out_bus),
      .B  (regB_out_bus),
      .K  (K),
      .mem_data(dmem_out),
      .sel(selB),
      .out(alu_b_bus)
  );

  alu ALU (
      .a  (alu_a_bus),
      .b  (alu_b_bus),
      .s  (alu_op),
      .out(alu_out_bus),
      .Z(Z),
      .N(N),
      .C(C),
      .V(V)
  );

  status status_reg (
      .clk(clk),
      .Z_in(Z),
      .N_in(N),
      .C_in(C),
      .V_in(V),
      .status_out(status_out)
  );

endmodule
