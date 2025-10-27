
module muxData (
  input  [7:0] A,
  input  [7:0] B,
  input  [7:0] K,
  input  [7:0] PC,
  input  [1:0] sel,
  output reg [7:0] out
);
  always @(*) begin
    case (sel)
      2'b00: out = B;
      2'b01: out = A;
      2'b10: out = K;
      2'b11: out = 8'h00;
      default: out = 8'h00;
    endcase
  end
endmodule
