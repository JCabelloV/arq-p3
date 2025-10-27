
module muxWB (
  input  [7:0] alu_out,
  input  [7:0] mem_out,
  input        sel,
  output [7:0] out
);
  assign out = sel ? mem_out : alu_out;
endmodule
