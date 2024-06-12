module buffer(
	input wrclk,
	input rdclk,
	input [18:0] wraddress,
	input [8:0] write_data,
	input wren,
	input [18:0] rdaddress,
	output reg [8:0] read_data
);

reg [8:0] memoria[307200];

always @(posedge wrclk) begin
	if(wren) begin
		memoria[wraddress] = write_data;
	end
end

always @(posedge rdclk) begin
	read_data = memoria[rdaddress];
end

endmodule