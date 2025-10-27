
module muxA (
  input  [7:0] A,
  input  [7:0] B,
  input  [7:0] K_unused,
  input  [7:0] mem_data,
  input  [1:0] sel,
  output reg [7:0] out
);
  always @(*) begin
    case (sel)
      2'b00: out = A;
      2'b01: out = B;
      2'b10: out = 8'h00;
      2'b11: out = mem_data;
      default: out = 8'h00;
    endcase
  end
endmodule
