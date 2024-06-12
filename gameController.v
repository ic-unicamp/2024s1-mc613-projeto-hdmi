module gameController(
	input CLOCK_50,
	input reset,
	input start,
	input collision,
	output reg gameon
);

reg [1:0] state;
parameter [1:0] pregame = 0;
parameter [1:0] game = 1;
parameter [1:0] over = 2;


always @(posedge CLOCK_50) begin
	if(reset) begin
		gameon = 0;
		state = 0;
	end else begin
		case(state)
			pregame: begin
				if(start) state = game;
			end
			game: begin
				gameon = 1;
				if(collision) state = over;
			end
			over: begin
				gameon = 0;
				if(start) state = game;
			end
		endcase
	end
end

endmodule