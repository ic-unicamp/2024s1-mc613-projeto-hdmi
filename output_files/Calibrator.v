module Calibrator(
	input CLOCK_50,
	input reset,
	input [3:0] KEY,
	output reg [7:0] crt,
	output reg [7:0] cbt
);

wire crbup;
assign crbup = !KEY[3];
wire crbdown;
assign crbdown = !KEY[2];
wire cbbup;
assign cbbup = !KEY[1];
wire cbbdown;
assign cbbdown = !KEY[0];

reg [2:0] state;
parameter [2:0] read = 0;
parameter [2:0] crbupstate = 1;
parameter [2:0] crbdownstate = 2;
parameter [2:0] cbbupstate = 3;
parameter [2:0] cbbdownstate = 4;

always @(posedge CLOCK_50) begin
	if(reset) begin
		state = 0;
		crt = 8'd150;
		cbt = 8'd150;
	end else begin
		case(state)
			read: begin
				if(crbup) state = crbupstate;
				if(crbdown) state = crbdownstate;
				if(cbbup) state = cbbupstate;
				if(cbbdown) state = cbbdownstate;
			end
			crbupstate: begin
				if(!crbup) begin
					crt = crt + 1'b1;
					state = read;
				end
			end
			crbdownstate: begin
				if(!crbdown) begin
					crt = crt - 1'b1;
					state = read;
				end
			end
			cbbupstate: begin
				if(!cbbup) begin
					cbt = cbt + 1'b1;
					state = read;
				end
			end
			cbbdownstate: begin
				if(!cbbdown) begin
					cbt = cbt - 1'b1;
					state = read;
				end
			end
		endcase
	end
end

endmodule