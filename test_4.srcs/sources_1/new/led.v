`timescale 1ns / 1ps

module led(
    input clock_100Mhz,
    input [7:0] Num_key,
    input reset,
    output reg [3:0] Anode_Activate, //LED control
    output reg [6:0] LED_out //cathode control
);
    
    reg [7:0] displayed_number; //number16bit
    reg [3:0] LED_BCD; //4-digit number
    
    reg [26:0] one_second_counter;
    wire one_second_enable;

    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    
    always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            displayed_number <= 0;
        else if(one_second_enable==1) begin
            case(Num_key)
            8'h30: displayed_number = 8'd0;
            8'h31: displayed_number = 8'd1;
            8'h32: displayed_number = 8'd2;
            8'h33: displayed_number = 8'd3;
            8'h34: displayed_number = 8'd4;
            8'h35: displayed_number = 8'd5;
            8'h36: displayed_number = 8'd6;
            8'h37: displayed_number = 8'd7;
            8'h38: displayed_number = 8'd8;
            8'h39: displayed_number = 8'd9;
            default: displayed_number = 8'd10;
            endcase
        end
    end
            
    always @(*)
    begin
        if(displayed_number == 8'd10)
            Anode_Activate = 4'b1111;
            
        else begin
            Anode_Activate = 4'b1110; 
            LED_BCD = ((displayed_number % 1000)%100)%10;     
        end       
    end
    
    //Cathode seg
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 7'b0000001; // "0"
        endcase
    end
    
 endmodule