module fpga_top (
    input clk,
    input [3:0] btn,
    output [3:0] led,
    output [6:0] seg,
    output [1:0] digit_sel
);
    localparam integer CPU_DIVIDER = 6_250_000; // 25 MHz / (2 * 6_250_000) = 2 Hz

    reg [22:0] cpu_counter = 0;
    reg cpu_clk = 0;

    always @(posedge clk) begin
        if (cpu_counter == CPU_DIVIDER - 1) begin
            cpu_counter <= 0;
            cpu_clk <= ~cpu_clk;
        end else begin
            cpu_counter <= cpu_counter + 1;
        end
    end

    wire [7:0] alu_out;
    wire [7:0] regA_value;
    wire [7:0] regB_value;

    computer cpu (
        .clk(cpu_clk),
        .alu_out_bus(alu_out),
        .regA_out(regA_value),
        .regB_out(regB_value)
    );

    wire buttons_active = |btn;
    wire [3:0] core_value = regB_value[3:0];
    wire [3:0] display_value = buttons_active ? btn : core_value;

    assign led = buttons_active ? btn : core_value;

    reg [3:0] tens;
    reg [3:0] ones;

    always @(*) begin
        if (display_value > 4'd9) begin
            tens = 4'd1;
            ones = display_value - 4'd10;
        end else begin
            tens = 4'd0;
            ones = display_value;
        end
    end

    reg [15:0] refresh_counter = 0;
    reg active_digit = 0;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 16'd0) begin
            active_digit <= ~active_digit;
        end
    end

    wire [6:0] seg_tens;
    wire [6:0] seg_ones;

    seven_seg_decoder decoder_tens (
        .value(tens),
        .segments(seg_tens)
    );

    seven_seg_decoder decoder_ones (
        .value(ones),
        .segments(seg_ones)
    );

    wire suppress_tens = (tens == 4'd0);

    assign seg = active_digit ? seg_ones : (suppress_tens ? 7'b1111111 : seg_tens);
    assign digit_sel = active_digit ? 2'b10 : 2'b01;
endmodule

module seven_seg_decoder (
    input [3:0] value,
    output reg [6:0] segments
);
    always @(*) begin
        case (value)
            4'd0: segments = 7'b1000000;
            4'd1: segments = 7'b1111001;
            4'd2: segments = 7'b0100100;
            4'd3: segments = 7'b0110000;
            4'd4: segments = 7'b0011001;
            4'd5: segments = 7'b0010010;
            4'd6: segments = 7'b0000010;
            4'd7: segments = 7'b1111000;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0010000;
            default: segments = 7'b1111111;
        endcase
    end
endmodule
