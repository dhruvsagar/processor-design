
module assignment1_frame(
	input        CLOCK_50,
	input        RESET_N,
	input  [3:0] KEY,
//	input  [9:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [9:0] LEDR
);

	
	
	wire clk;
	wire rst;

	reg [3:0] state_number = 2;
		
	wire key0_triggered;
	wire key1_triggered;
	
	reg [1:0] state = 1;
	reg [5:0] current_state = 1;
	reg [9:0] red_lights = 0;
	reg [31:0] count = 1;
	reg [31:0] blink_reg = 32'd25000000;

	reg key0_reg = 0;
	reg key1_reg = 0;
	
	
	assign clk = CLOCK_50;
	assign rst = ~RESET_N;


	assign key0_triggered = ~KEY[0] && ~key0_reg;
	assign key1_triggered = ~KEY[1] && ~key1_reg;
	
	// key0_triggered and key1_triggered signales works like an edge triggered signal 
		
	

	
	always@(posedge clk or posedge rst)
	begin
		if(rst) begin
			key0_reg <= 1'b0;
			key1_reg <= 1'b0;
			blink_reg <= 32'd25000000;
			state_number <= 2;
		end
		else begin
			key0_reg <= ~KEY[0];
			key1_reg <= ~KEY[1];
			if (key0_triggered)
				if (blink_reg < 100000000) begin
					blink_reg <= blink_reg + 12500000;
					state_number <= state_number + 1;
				end
			else if (key1_triggered)
				if (blink_reg > 12500000) begin
					blink_reg <= blink_reg - 12500000;
					state_number <= state_number - 1;
				end
		end
	end
	   
	/*always@(posedge clk or posedge rst)
	begin: KEY1_REG
		if(rst) begin
			key1_reg <= 1'b0;
			//blink_reg <= 32'd25000000;
		end
		else begin
			key1_reg <= ~KEY[1];
			if (key1_triggered)
				if (blink_reg > 12500000) begin
					blink_reg <= blink_reg - 12500000;
					state_number <= state_number - 1;
				end
		end
	end*/
	
						
	always@(posedge clk or posedge rst)begin 
		if (rst) begin
			red_lights <= 0;
			count <= 1;
			current_state <= 1;
			state <= 1;
		end
		else if (count == blink_reg) begin
			count <= 1;
			if (current_state > 6) begin
				if (state == 3) begin 
					state <= 1;
					red_lights <= 0;
				end
				else state <= state + 1;
				current_state <= 1;
			end
			
			if (current_state <= 6) begin
				if (state == 1) begin
					red_lights <= red_lights ^ 10'b1111100000;
					current_state <= current_state + 1;
				end
				if (state == 2) begin
					red_lights <= red_lights ^ 10'b0000011111;
					current_state <= current_state + 1;
				end
				if (state == 3) begin
					if (current_state == 1)
						red_lights <= 10'b1111100000;
					else 
						red_lights <= red_lights ^ 10'b1111111111;
					current_state <= current_state + 1;
				end
			end
		end
		else count <= count + 1;
				
			
	end

	
		
	/* For debugging */
	  assign LEDR[0]= red_lights[0];
	  assign LEDR[1]= red_lights[1];
	  assign LEDR[2]= red_lights[2];
	  assign LEDR[3]= red_lights[3];
	  assign LEDR[4]= red_lights[4];
	  assign LEDR[5]= red_lights[5];
	  assign LEDR[6]= red_lights[6];
	  assign LEDR[7]= red_lights[7];
	  assign LEDR[8]= red_lights[8];
	  assign LEDR[9]= red_lights[9];
	
	SevenSeg ss0(.IN(state_number),.OFF(1'b0),.OUT(HEX3));
	/*
	SevenSeg ss1(.IN(timer[31:28]),.OFF(1'b0),.OUT(HEX1));
	SevenSeg ss2(.IN(timer[27:24]),.OFF(1'b0),.OUT(HEX2));
	SevenSeg ss3(.IN(timer[23:20]),.OFF(1'b0),.OUT(HEX3));
	SevenSeg ss4(.IN(timer[19:16]),.OFF(1'b0),.OUT(HEX4));
	SevenSeg ss5(.IN(blink_reg),.OFF(1'b0),.OUT(HEX5));
	*/

	
endmodule