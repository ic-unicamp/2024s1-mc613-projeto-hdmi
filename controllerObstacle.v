module controllerObstacle(
  input CLOCK_50,
  input reset,
  // USAR OS TIPOS DE OBSTÁCULO COMO INPUT?
  input [1:0] obstacle_trigger,
  input [9:0] obstacle_start_x,
  output reg [9:0] obstacle_x,
  output reg [9:0] obstacle_y
);

// Obstacle parameters
parameter [9:0] obstacle_size_x = 32;
parameter [9:0] obstacle_size_y = 32;
parameter [9:0] obstacle_start_y = 0;
parameter [9:0] step = 4;

always @(posedge CLOCK_50) begin

    if (obstacle_trigger) begin
    
        obstacle_x <= obstacle_start_x;
        obstacle_y <= obstacle_start_y;

        if (obstacle_y < 640 - obstacle_size_y) begin
            obstacle_y <= obstacle_y + step;
        end
    
    end
end

endmodule