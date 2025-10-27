
module control(
    input  [6:0] opcode,
    input  [3:0] status,
    output reg   LA,
    output reg   LB,
    output reg   LP,
    output reg   mem_we,
    output reg   wbSel,
    output reg [1:0] selA,
    output reg [1:0] selB,
    output reg [1:0] selData,
    output reg [3:0] alu_op
);

  always @(*) begin
    LA      = 1'b0;     
    LB      = 1'b0;
    LP      = 1'b0;
    mem_we  = 1'b0;
    wbSel   = 1'b0;     
    selA    = 2'b00;    
    selB    = 2'b00;    
    selData = 2'b00;    
    alu_op  = 4'b0000;   
    
    case (opcode)
      7'b0000000: begin
        LA     = 1; 
        selA   = 2'b10;
        selB   = 2'b00;
        alu_op = 4'b0000;
      end
      
      7'b0000001: begin
        LB     = 1; 
        selA   = 2'b10;
        selB   = 2'b01;
        alu_op = 4'b0000;
      end

      7'b0000010: begin
        LA     = 1; 
        selA   = 2'b10;
        selB   = 2'b10;
        alu_op = 4'b0000;
      end

      7'b0000011: begin
        LB     = 1; 
        selA   = 2'b10;
        selB   = 2'b10;
        alu_op = 4'b0000;
      end

      7'b0000100: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0000;
      end

      7'b0000101: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b01;
        alu_op = 4'b0000;
      end

      7'b0000110: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b10;
        alu_op = 4'b0000;
      end

      7'b0000111: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b10;
        alu_op = 4'b0000;
      end

      7'b0001000: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0001;
      end

      7'b0001001: begin
        LB     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0001;
      end

      7'b0001010: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b10;
        alu_op = 4'b0001;
      end

      7'b0001011: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b10;
        alu_op = 4'b0001;
      end

      7'b0001100: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0010;
      end

      7'b0001101: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b01;
        alu_op = 4'b0010;
      end

      7'b0001110: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b10;
        alu_op = 4'b0010;
      end

      7'b0001111: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b10;
        alu_op = 4'b0010;
      end

      7'b0010000: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0011;
      end

      7'b0010001: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b01;
        alu_op = 4'b0011;
      end

      7'b0010010: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b10;
        alu_op = 4'b0011;
      end

      7'b0010011: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b10;
        alu_op = 4'b0011;
      end

      7'b0010100: begin
        LA     = 1; 
        selA   = 2'b00;
        alu_op = 4'b0101;
      end

      7'b0010101: begin
        LA     = 1; 
        selA   = 2'b01;
        alu_op = 4'b0110;
      end

      7'b0010110: begin
        LB     = 1; 
        selA   = 2'b00;
        alu_op = 4'b0101;
      end

      7'b0010111: begin
        LB     = 1; 
        selA   = 2'b01;
        alu_op = 4'b0110;
      end

      7'b0011000: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0100;
      end

      7'b0011001: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b01;
        alu_op = 4'b0100;
      end

      7'b0011010: begin
        LA     = 1; 
        selA   = 2'b00;
        selB   = 2'b10;
        alu_op = 4'b0100;
      end

      7'b0011011: begin
        LB     = 1; 
        selA   = 2'b01;
        selB   = 2'b10;
        alu_op = 4'b0100;
      end

      7'b0011100: begin
        LA     = 1; 
        selA   = 2'b00;
        alu_op = 4'b0111;
      end

      7'b0011101: begin
        LA     = 1; 
        selA   = 2'b01;
        alu_op = 4'b0111;
      end

      7'b0011110: begin
        LB     = 1; 
        selA   = 2'b00;
        alu_op = 4'b0111;
      end

      7'b0011111: begin
        LB     = 1; 
        selA   = 2'b01;
        alu_op = 4'b0111;
      end

      7'b0100000: begin
        LA     = 1; 
        selA   = 2'b00;
        alu_op = 4'b1000;
      end

      7'b0100001: begin
        LA     = 1; 
        selA   = 2'b01;
        alu_op = 4'b1000;
      end

      7'b0100010: begin
        LB     = 1; 
        selA   = 2'b00;
        alu_op = 4'b1000;
      end

      7'b0100011: begin
        LB     = 1; 
        selA   = 2'b01;
        alu_op = 4'b1000;
      end

      7'b0100100: begin
        LB     = 1;
        selA   = 2'b01;
        alu_op = 4'b1001;
      end

      7'b0100101: begin
        LA      = 1;
        wbSel   = 1;
        selData = 2'b10;
      end

      7'b0100110: begin
        LB      = 1;
        wbSel   = 1;
        selData = 2'b10;
      end

      7'b0100111: begin
        mem_we  = 1;
        selA    = 2'b10;
        selB    = 2'b01;
        selData = 2'b10;
        alu_op  = 4'b0000;
      end

      7'b0101000: begin
        mem_we  = 1;
        selA    = 2'b10;
        selB    = 2'b00;
        selData = 2'b10;
        alu_op  = 4'b0000;
      end

      7'b0101001: begin
        LA      = 1;
        wbSel   = 1;
        selData = 2'b00;
      end

      7'b0101010: begin
        LB      = 1;
        wbSel   = 1;
        selData = 2'b00;
      end

      7'b0101011: begin
        mem_we  = 1;
        selA    = 2'b10;
        selB    = 2'b01;
        selData = 2'b00;
        alu_op  = 4'b0000;
      end

      7'b0101100: begin
        LA      = 1;
        wbSel   = 0;
        selA    = 2'b00;
        selB    = 2'b11;
        selData = 2'b10;
        alu_op  = 4'b0000;
      end

      7'b0101101: begin
        LB      = 1;
        wbSel   = 0;
        selA    = 2'b01;
        selB    = 2'b11;
        selData = 2'b10;
        alu_op  = 4'b0000;
      end

      7'b0101110: begin
        LA      = 1;
        wbSel   = 0;
        selA    = 2'b00;
        selB    = 2'b11;
        selData = 2'b00;
        alu_op  = 4'b0000;
      end

      7'b0101111: begin
        mem_we  = 1;
        selA    = 2'b00;
        selB    = 2'b00;
        selData = 2'b10;
        alu_op  = 4'b0000;
      end

      7'b0110000: begin
        LA      = 1;
        wbSel   = 0;
        selA    = 2'b00;
        selB    = 2'b11;
        selData = 2'b10;
        alu_op  = 4'b0001;
      end

      7'b0110001: begin
        LB      = 1;
        wbSel   = 0;   
        selA    = 2'b01;
        selB    = 2'b11;
        selData = 2'b10;
        alu_op  = 4'b0001;
      end

      7'b0110010: begin
        LA      = 1;
        wbSel   = 0;      
        selA    = 2'b00;
        selB    = 2'b11;  
        selData = 2'b00;   
        alu_op  = 4'b0001; 
      end

      7'b0110011: begin
        mem_we  = 1;     
        selA    = 2'b00;
        selB    = 2'b00;
        selData = 2'b10;   
        alu_op  = 4'b0001; 
      end

      7'b0110100: begin
        LA      = 1;
        wbSel   = 0;        
        selA    = 2'b00;
        selB    = 2'b11;    
        selData = 2'b10;   
        alu_op  = 4'b0010; 
      end

      7'b0110101: begin
        LB      = 1;
        wbSel   = 0;     
        selA    = 2'b01;
        selB    = 2'b11; 
        selData = 2'b10;   
        alu_op  = 4'b0010;
      end

      7'b0110110: begin
        LA      = 1;
        wbSel   = 0;     
        selA    = 2'b00;
        selB    = 2'b11;  
        selData = 2'b00;  
        alu_op  = 4'b0010;
      end

      7'b0110111: begin
        mem_we  = 1;     
        selA    = 2'b00;
        selB    = 2'b00;
        selData = 2'b10;
        alu_op  = 4'b0010; 
      end

      7'b0111000: begin
        LA      = 1;
        wbSel   = 0;    
        selA    = 2'b00;
        selB    = 2'b11;   
        selData = 2'b10;  
        alu_op  = 4'b0011; 
      end

      7'b0111001: begin
        LB      = 1;
        wbSel   = 0;      
        selA    = 2'b01;
        selB    = 2'b11;  
        selData = 2'b10;  
        alu_op  = 4'b0011;
      end

      7'b0111010: begin
        LA      = 1;
        wbSel   = 0;    
        selA    = 2'b00;
        selB    = 2'b11;  
        selData = 2'b00;  
        alu_op  = 4'b0011; 
      end

      7'b0111011: begin
        mem_we  = 1;      
        selA    = 2'b00;
        selB    = 2'b00;
        selData = 2'b10;  
        alu_op  = 4'b0011; 
      end

      7'b0111100: begin
        mem_we  = 1;        
        selA    = 2'b00;
        selData = 2'b10;    
        alu_op  = 4'b0101;  
      end

      7'b0111101: begin
        mem_we  = 1;        
        selA    = 2'b01;
        selData = 2'b10;   
        alu_op  = 4'b0110;  
      end

      7'b0111110: begin
        mem_we  = 1;       
        selA    = 2'b00;
        selData = 2'b00;  
        alu_op  = 4'b0101;  
      end

      7'b0111111: begin
        LA      = 1;
        wbSel   = 0;      
        selA    = 2'b00;
        selB    = 2'b11;   
        selData = 2'b10;   
        alu_op  = 4'b0100;  
      end

      7'b1000000: begin
        LB      = 1;
        wbSel   = 0;      
        selA    = 2'b01;
        selB    = 2'b11; 
        selData = 2'b10;  
        alu_op  = 4'b0100;
      end

      7'b1000001: begin
        LA      = 1;
        wbSel   = 0;     
        selA    = 2'b00;
        selB    = 2'b11;   
        selData = 2'b00;   
        alu_op  = 4'b0100; 
      end

      7'b1000010: begin
        mem_we  = 1;       
        selA    = 2'b00;
        selB    = 2'b00;
        selData = 2'b10;    
        alu_op  = 4'b0100; 
      end

      7'b1000011: begin
        mem_we  = 1;       
        selA    = 2'b00;
        selData = 2'b10;   
        alu_op  = 4'b0111;  
      end

      7'b1000100: begin
        mem_we  = 1;       
        selA    = 2'b01;
        selData = 2'b10;   
        alu_op  = 4'b0111; 
      end

      7'b1000101: begin
        mem_we  = 1;       
        selA    = 2'b00;
        selData = 2'b00;   
        alu_op  = 4'b0111; 
      end

      7'b1000110: begin
        mem_we  = 1;       
        selA    = 2'b00;
        selData = 2'b10;   
        alu_op  = 4'b1000;  
      end

      7'b1000111: begin
        mem_we  = 1;      
        selA    = 2'b01;
        selData = 2'b10;   
        alu_op  = 4'b1000;
      end

      7'b1001000: begin
        mem_we  = 1;      
        selA    = 2'b00;
        selData = 2'b00;   
        alu_op  = 4'b1000;
      end

      7'b1001001: begin
        mem_we  = 1;
        wbSel   = 0;
        selA    = 2'b11;
        selData = 2'b10;   
        alu_op  = 4'b1001; 
      end

      7'b1001010: begin
        mem_we  = 1;
        wbSel   = 0;
        selA    = 2'b11;
        selData = 2'b00;   
        alu_op  = 4'b1001; 
      end

      7'b1001011: begin
        mem_we  = 1;       
        selData = 2'b10;   
        alu_op  = 4'b1010;  
      end

      7'b1001100: begin
        mem_we  = 1;     
        selData = 2'b00;  
        alu_op  = 4'b1010; 
      end

      7'b1001101: begin
        selA   = 2'b00;
        selB   = 2'b00;
        alu_op = 4'b0001;  
      end

      7'b1001110: begin
        selA   = 2'b00;
        selB   = 2'b10;   
        alu_op = 4'b0001;  
      end

      7'b1001111: begin
        selA   = 2'b01;
        selB   = 2'b10;   
        alu_op = 4'b0001;  
      end

      7'b1010000: begin
        selA    = 2'b00;
        selB    = 2'b11;   
        selData = 2'b10; 
        alu_op  = 4'b0001;
      end

      7'b1010001: begin
        selA    = 2'b01;
        selB    = 2'b11;    
        selData = 2'b10;  
        alu_op  = 4'b0001;
      end 

      7'b1010010: begin
        selA    = 2'b00;
        selB    = 2'b11;  
        selData = 2'b00;   
        alu_op  = 4'b0001; 
      end

      7'b1010011: begin
        LP = 1;          
      end

      7'b1010100: begin
        if (status[0])
          LP = 1;
      end

      7'b1010101: begin
        if (!status[0])
          LP = 1;
      end

      7'b1010110: begin
        if (!status[1] && !status[0])
          LP = 1;
      end

      7'b1010111: begin
        if (status[1])
          LP = 1;
      end

      7'b1011000: begin
        if (!status[1])
          LP = 1;
      end

      7'b1011001: begin
        if (status[1] || status[0])
          LP = 1;
      end

      7'b1011010: begin
        if (status[2])
          LP = 1;
      end

      7'b1011011: begin
        if (status[3])
          LP = 1;
      end

      default: begin
      end
    endcase
  end

endmodule
