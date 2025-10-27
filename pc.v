
module pc (
    input clk,
    input LP,
    input [7:0] K,
    output reg [7:0] pc
);

  initial begin
    pc = 0;
  end

  always @(posedge clk) begin
    if (LP)
      pc <= K;
    else
      pc <= pc + 1;
  end
endmodule
