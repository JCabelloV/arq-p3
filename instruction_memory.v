module instruction_memory (
  input  [7:0]  address,
  output [14:0] out
);
  reg [14:0] mem [0:15];  // Solo 16 posiciones

  initial begin
    $readmemb("im.dat", mem);
  end

  integer i;
  initial begin
    #0.1;
    for (i = 0; i < 256; i = i + 1) begin
      if (^mem[i] === 1'bx) mem[i] = 16'h0000;
    end
  end

  assign out = mem[address];
endmodule
