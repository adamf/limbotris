include "sys.m";
include "rand.m";
include "draw.m";
include "tk.m";
include "wmlib.m";

sys : Sys;
draw : Draw;
tk : Tk;
wmlib : Wmlib;
rand : Rand;
   
Toplevel: import Tk;  
FD : import Sys;

shape : adt {
   value : array of array of int;
   next_shape: int;
   prev_shape: int;
   array_width: int;
   array_hieght: int;
   color : int;
};

shapes := array[19] of shape;
B_COLS : con 12;
B_ROWS : con 23;
B_SIZE : con (B_COLS * B_ROWS);
D_FIRST : con 1;
D_LAST : con 22;
A_FIRST_ROW : con 1;
A_LAST_ROW : con 21;
A_FIRST_COL : con 1;
A_LAST_COL : con 11;
BLOCKSIZE : con 20;
BOARD_WIDTH : con (10 * BLOCKSIZE); 
BOARD_HEIGHT : con (21 * BLOCKSIZE);

position : adt {
   x, y : int;
};

cell : type int;

board := array[B_ROWS] of { * => array[B_COLS] of { * => 0 }};
score, level : int;
pixel_pos : position; 
cell_pos : position;
curr_shape : shape;
next_shape : shape;
timeout : int;

Tetris: module
{
   init: fn(ctxt: ref Draw->Context, argv: list of string);
   does_it_fit: fn(cell_y, cell_x : int, s : shape) : int;
   setup_shapes: fn();
   setup_board: fn();
   new_shape: fn() : shape;
   can_it_fall: fn() : int;
   game_over: fn();
   rm_line: fn(t : ref Toplevel);
   get_color : fn(color_val : int) : string;
   update_screen: fn(t : ref Toplevel);
   timer: fn(time_chan_send, time_chan_receive: chan of string);
   place_shape: fn(onoff: int, s : shape);
   cells_to_pixels: fn(x: cell, y: cell) : (int, int);
};

