
module status (
  input  clk,
  input  Z_in,
  input  N_in,
  input  C_in,
  input  V_in,
  output [3:0] status_out
);
  reg Z, N, C, V;
  
  assign status_out = {V, C, N, Z};

  always @(posedge clk) begin 
    Z <= Z_in;
    N <= N_in;
    C <= C_in;
    V <= V_in;
  end
endmodule
