
module alu (
    a,
    b,
    s,
    out,
    Z,
    N,
    C,
    V
);
  input [7:0] a, b;
  input [3:0] s;
  output [7:0] out;
  output Z, N, C, V;

  reg [7:0] out_r;
  reg C_r, V_r;

  wire [8:0] sum = {1'b0, a} + {1'b0, b};
  wire [8:0] diff = {1'b0, a} + {1'b0, ~b} + 9'd1;

  always @(*) begin
    C_r = 1'b0;
    V_r = 1'b0;
    case (s)
      4'b0000: begin
        out_r = sum[7:0];
        C_r   = sum[8];
        V_r   = (a[7] == b[7]) && (out_r[7] != a[7]);
      end
      4'b0001: begin
        out_r = diff[7:0];
        C_r   = ~diff[8];
        V_r   = (a[7] != b[7]) && (out_r[7] != a[7]);
      end
      4'b0010: out_r = a & b;
      4'b0011: out_r = a | b;
      4'b0100: out_r = a ^ b;
      4'b0101: out_r = ~a;
      4'b0110: out_r = ~b;
      4'b0111: begin
        out_r = {a[6:0], 1'b0};
        C_r   = a[7];
      end
      4'b1000: begin
        out_r = {1'b0, a[7:1]};
        C_r   = a[0];
      end
      4'b1001: begin
        {C_r, out_r} = a + 8'd1;
        V_r = (a == 8'h7F);
      end
      4'b1010: begin
        out_r = 8'h00;
      end
      default: out_r = 8'h00;
    endcase
  end

  assign out = out_r;
  assign Z   = (out_r == 8'h00);
  assign N   = out_r[7];
  assign C   = C_r;
  assign V   = V_r;
endmodule
