`timescale 1ns / 1ps
module top
	(	
		input wire clk, reset,
		input wire ps2d, ps2c,
        output wire hsync, vsync,
		output wire [3:0] R,
		output wire [3:0] G,
		output wire [3:0] B	
	);
		
	wire [7:0] scan_code, ascii_code;
	reg [7:0] ascii_char;
	wire scan_code_ready;
	wire letter_case;
	reg [2:0] rgb_reg; 
	wire [2:0] rgb_next;
	wire video_on, p_tick;
	wire [9:0] x, y;
		 
	vga vga_sync (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(p_tick), .x(x), .y(y));                               
	key kb_unit (.clk(clk), .reset(reset), .ps2d(ps2d), .ps2c(ps2c), .scan_code(scan_code), .scan_code_ready(scan_code_ready), .letter_case_out(letter_case));						
	ascii k2a_unit (.letter_case(letter_case), .scan_code(scan_code), .ascii_code(ascii_code));
	
	always @(*) begin
	   case(ascii_code)
	   8'h30: ascii_char = ascii_code;
	   8'h31: ascii_char = ascii_code;
	   8'h32: ascii_char = ascii_code;
	   8'h33: ascii_char = ascii_code;
	   8'h34: ascii_char = ascii_code;
	   8'h35: ascii_char = ascii_code;
	   8'h36: ascii_char = ascii_code;
	   8'h37: ascii_char = ascii_code;
	   8'h38: ascii_char = ascii_code;
	   8'h39: ascii_char = ascii_code;
	   8'h0d: ascii_char = ascii_code;
	   default: ascii_char = 8'h45;
	   endcase
	end
	   
    font_gen font_gen_unit (.clk(clk), .video_on(video_on), .pixel_x(x), .pixel_y(y), .ascii(ascii_char[6:0]), .rgb_text(rgb_next));
    
    assign R=rgb_next[2]? 4'b1111:0;
	assign G=rgb_next[1]? 4'b1111:0;
	assign B=rgb_next[0]? 4'b1111:0;
    
endmodule
