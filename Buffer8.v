module Buffer8(
	input wrclk,
	input rdclk,
	input [18:0] wraddress,
	input [7:0] write_data,
	input wren,
	input [18:0] rdaddress,
	output reg [7:0] read_data
);

reg [7:0] memoria[307200];
reg [18:0] wraddress2;

always @(posedge wrclk) begin
	if(wren) begin
		//memoria[wraddress] = 9'b111111111;
		memoria[wraddress] = write_data;
		//wraddress2 = wraddress + 1;
		//memoria[wraddress2] = write_data[8:0];
	end
end

always @(posedge rdclk) begin
	read_data = memoria[rdaddress];
end

endmodule