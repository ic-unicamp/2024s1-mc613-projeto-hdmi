module Projeto (
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output CLOCK_24,
	inout [35:0] GPIO_0,
	output VGA_CLK,
   output VGA_HS,
	output VGA_VS,	
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B,
	output VGA_BLANK_N,
	output VGA_SYNC_N
);

wire reset = SW[0];
wire start = SW[3];
wire resetsccb = SW[1];
wire[7:0] pixel;
assign pixel = GPIO_0[7:0];
assign GPIO_0[8] = CLOCK_24;
wire href;
wire cam_vsync;
assign href = GPIO_0[10];
assign cam_vsync = GPIO_0[11];
wire pclk;
assign pclk = GPIO_0[9];
assign sio_d = GPIO_0[24];
assign sio_c = GPIO_0[25];

wire [9:0] next_x_vga;
wire [9:0] next_y_vga;
wire wren;
wire [8:0] vga_out;
wire [9:0] next_x_cam;
wire [9:0] next_y_cam;

pll pll_inst (
	.refclk   (CLOCK_50),   //  refclk.clk
	.rst      (reset),      //   reset.reset
	.outclk_0 (CLOCK_24), // outclk0.clk
	.locked   ()    //  locked.export
);

wire [18:0] next_cam;
wire [18:0] next_vga;

assign next_cam = next_x_cam + (640 * next_y_cam);
assign next_vga = next_x_vga + (640 * next_y_vga);

wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire [8:0] rgb;

vga vga_inst(
  .reset(reset),
  .CLOCK_50(CLOCK_50),
  .red(red),
  .green(green),
  .blue(blue),
  .VGA_CLK(VGA_CLK),
  .VGA_HS(VGA_HS),
  .VGA_VS(VGA_VS),
  .VGA_R(VGA_R),
  .VGA_G(VGA_G),
  .VGA_B(VGA_B),
  .VGA_BLANK_N(VGA_BLANK_N),
  .VGA_SYNC_N(VGA_SYNC_N),
  .next_x(next_x_vga),
  .next_y(next_y_vga),
  .line()
);

wire [9:0] posx;
wire [9:0] posy;

CameraRGB camera(
	.pclk(pclk),
	.reset(reset),
	.href(href),
	.wren(wren),
	.pixel(pixel),
	.cbt(cbt),
	.crt(crt),
	.cam_vsync(cam_vsync),
	.next_x(next_x_cam),
	.next_y(next_y_cam),
	.rgb(rgb),
	.posx(posx),
	.posy(posy)
);

wire [7:0] crt;
wire [7:0] cbt;

Calibrator Calibrator(
	.CLOCK_50(CLOCK_50),
	.reset(reset),
	.KEY(KEY),
	.crt(crt),
	.cbt(cbt)
);

Buffer buffer(
	.wrclk(pclk),
	.rdclk(VGA_CLK),
	.wraddress(next_cam),
	.write_data(rgb),
	.wren(wren),
	.rdaddress(next_vga),
	.read_data(vga_out)
);

wire [19:0] scrt;
assign scrt = {12'b000000000000, crt};
wire [19:0] scbt;
assign scbt = {12'b000000000000, cbt};
wire [23:0] bcdcrt;
wire [23:0] bcdcbt;
wire [23:0] display;
assign display = {bcdcrt[11:0], bcdcbt[11:0]};

bintobcd tobcdcrt(
	.valor_bin(scrt),
	.valor_bcd(bcdcrt)
);

bintobcd tobcdcbt(
	.valor_bin(scbt),
	.valor_bcd(bcdcbt)
);

bcd2decdisplay bcd2decdisplay(
	.valor(display),
   .digito0(HEX0), // _ _ _ _ _ D
	.digito1(HEX1), // _ _ _ _ D _
	.digito2(HEX2), // _ _ _ D _ _
	.digito3(HEX3), // _ _ D _ _ _
	.digito4(HEX4), // _ D _ _ _ _
	.digito5(HEX5)  // D _ _ _ _ _
);

wire barra_color;
wire barra_drawing;

spriteBarra spriteBarra(
	.clk(CLOCK_50),
	.reset(reset),
	.x(next_x_vga), 
	.y(next_y_vga), 
	.vsync(VGA_VS),
	.sprite_x(posx), 
	.sprite_y(posy),
	.color(barra_color),
	.drawing(barra_drawing)
);

//assign red = vga_out[7:0];
//assign green = vga_out[7:0];
//assign blue = vga_out[7:0];

assign red = (barra_drawing && barra_color) ? 9'b111111111 : {vga_out[8:6], 5'b00000};
assign green = (barra_drawing && barra_color) ? 9'b111111111 : {vga_out[5:3], 5'b00000};
assign blue = (barra_drawing && barra_color) ? 9'b111111111 : {vga_out[2:0], 5'b00000};

endmodule