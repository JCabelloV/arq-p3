module instruction_memory (
  input  [7:0]  address,
  output [14:0] out
);
  reg [14:0] mem [0:255];

  initial begin
    integer i;
    for (i = 0; i < 256; i = i + 1) begin
      mem[i] = 15'd0;
    end
    $readmemb("im.dat", mem);
  end

  assign out = mem[address];
endmodule
