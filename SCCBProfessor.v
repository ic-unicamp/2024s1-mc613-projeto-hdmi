module SCCBProfessor(
	input clk,
	input reset,
    input resetsccb,
	input start,
	output sio_c,
	output reg sio_d
);

reg [29:0] saida; 
reg [4:0] index;

reg state;
reg sio_clk_ctl;
reg sio_clk;

reg [9:0] counter;

always @(posedge clk) begin
	if (reset) begin
		counter = 0;
		sio_clk = 0;
	end else begin
		counter = counter + 1;
		if(counter == 10'b1111111111) sio_clk = !sio_clk;
	end
end	
	
assign sio_c = (sio_clk_ctl) ? sio_clk : 1;

always @(posedge sio_clk) begin
	if(resetsccb) begin
		sio_d = 0;
		sio_clk_ctl = 0;
		state = 0;
		saida = 30'b10_010000100_000100100_000001000_0;
		index = 29;
	end else begin
		case(state)
			0:begin
				sio_d = saida[29];
				if(start) begin
					state = 1;
					sio_clk_ctl = 1;
				end
			end
			1: begin
				index = index - 1;
				saida = {saida[28:0], 1'b0};
				sio_d = saida[29];
				if(index == 0) begin
					state = 0;
                    sio_d = 1;
					sio_clk_ctl = 0;
				end
			end
		endcase
	end
end

endmodule