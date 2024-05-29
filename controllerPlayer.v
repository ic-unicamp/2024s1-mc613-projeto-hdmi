module controllerPlayer(
  input CLOCK_50,
  // Não botei reset
  input left_button,
  input right_button,
  output reg [9:0] player_x,
  output reg [9:0] player_y
);

// Player parameters
parameter [9:0] player_size_x = 32;
parameter [9:0] player_size_y = 16;
parameter [9:0] player_start_x = (640/2) - (player_size_x/2);
parameter [9:0] player_start_y = (480-4) - player_size_y;
parameter [9:0] step = 4;

parameter [3:0] reading = 4'd0;
parameter [3:0] left = 4'd1;
parameter [3:0] right = 4'd2;

reg [3:0] buttonState;
reg [31:0] counter;

always @(posedge CLOCK_50) begin

	// VAI SER SUBSTITUÍDO PELO CONTROLE DE "CÂMERA"
	case (buttonState)
		reading: begin // Leitura
			counter = 0;
			if (left_button == 0) buttonState  = left;
			if (right_button == 0) buttonState = right;
		end
		left: begin
			counter = counter + 1;
			if(counter >= 10000000/8 && player_x > 0) begin
				player_x = player_x - step;
				counter = 0;
			end
			if (left_button==1) begin
				if(player_x > 0) player_x = player_x - step;
				buttonState = reading;
			end
		end
		right: begin
			counter = counter + 1;
			if(counter >= 10000000/8 && player_x < 639-player_size_x) begin
				player_x = player_x + step;
				counter = 0;
			end
			if (right_button == 1) begin
				if (player_x < 639-player_size_x) player_x = player_x + step;
				buttonState = reading;
			end 
		end
	endcase
end

endmodule