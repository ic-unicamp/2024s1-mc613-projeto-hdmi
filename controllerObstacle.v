module controllerObstacle(
  input clk,
  input reset,
  // USAR OS TIPOS DE OBSTÁCULO COMO INPUT?
  input obstacle_trigger,
  input [9:0] obstacle_start_x,
  input [9:0] obstacle_start_y,
  output reg [9:0] obstacle_x,
  output reg [9:0] obstacle_y
);

// Obstacle parameters
parameter [9:0] obstacle_size_x = 32;
parameter [9:0] obstacle_size_y = 32;
parameter [9:0] step = 4;


always @(posedge clk) begin
	
	if(reset) begin
	obstacle_y =  obstacle_start_y;
	obstacle_x = obstacle_start_x;
	
	end else begin
		if(obstacle_trigger) begin
			if (obstacle_y < (480 - obstacle_size_y)) begin
				obstacle_y = obstacle_y + step;
			end else begin
				obstacle_y = 0;
				obstacle_x = obstacle_start_x;
			end
		end
	end
	 
end

endmodule