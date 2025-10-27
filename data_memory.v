module data_memory (
    input  clk,
    input  W,
    input  [7:0] address,
    input  [7:0] data_in,
    output [7:0] data_out
);
    reg [7:0] mem [0:255];

    assign data_out = mem[address];

    always @(posedge clk) begin
        if (W) begin
            mem[address] <= data_in;
        end
    end

    initial begin
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 8'd0;
        end
        $readmemb("mem.dat", mem);
    end

endmodule
