module register (
    clk,
    data,
    load,
    out
);
  input clk, load;
  input [7:0] data;
  output [7:0] out;

  wire clk, load;
  wire [7:0] data;
  reg  [7:0] out;

  initial begin
    out = 0;
  end

  always @(posedge clk) begin
    if (load) begin
      out <= data;
    end
  end
endmodule
