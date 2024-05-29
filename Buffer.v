module Buffer(
	input wrclk,
	input rdclk,
	input [9:0] wraddress_x,
	input [9:0] wraddress_y,
	input [7:0] write_data,
	input wren,
	input [9:0] rdaddress_x,
	input [9:0] rdaddress_y,
	output reg [7:0] read_data
);

reg [7:0] memoria[480][640];

always @(posedge wrclk) begin
	if(wren) memoria[wraddress_y][wraddress_x] = write_data;
end

always @(posedge rdclk) begin
	read_data = memoria[rdaddress_y][rdaddress_x];
end

endmodule