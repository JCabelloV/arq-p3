module fpga_top (
    input clk,
    output [3:0] led,
    output [6:0] seg,
    output [1:0] digit_sel
);

    reg [25:0] counter;
    reg slow_clk;
    wire [7:0] alu_out;
    
    // Divisor de clock: 25MHz -> ~2Hz (para ver el contador)
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 26'd6_250_000) begin  // ~4Hz = cambio cada 0.25s
            slow_clk <= ~slow_clk;
            counter <= 0;
        end
    end
    
    // Instanciar tu computador completo
    computer cpu (
        .clk(slow_clk),
        .alu_out_bus(alu_out)
    );
    
    // LEDs muestran los 4 bits menos significativos en binario
    assign led = alu_out[3:0];
    
    // Display muestra en decimal
    seven_seg_decoder decoder (
        .value(alu_out[3:0]),
        .segments(seg)
    );
    
    // Ambos displays activos
    assign digit_sel = 2'b11;

endmodule

module seven_seg_decoder (
    input [3:0] value,
    output reg [6:0] segments
);
    always @(*) begin
        case (value)
            4'd0:  segments = 7'b1000000;
            4'd1:  segments = 7'b1111001;
            4'd2:  segments = 7'b0100100;
            4'd3:  segments = 7'b0110000;
            4'd4:  segments = 7'b0011001;
            4'd5:  segments = 7'b0010010;
            4'd6:  segments = 7'b0000010;
            4'd7:  segments = 7'b1111000;
            4'd8:  segments = 7'b0000000;
            4'd9:  segments = 7'b0010000;
            4'd10: segments = 7'b0001000;
            4'd11: segments = 7'b0000011;
            4'd12: segments = 7'b1000110;
            4'd13: segments = 7'b0100001;
            4'd14: segments = 7'b0000110;
            4'd15: segments = 7'b0001110;
            default: segments = 7'b1111111;
        endcase
    end
endmodule