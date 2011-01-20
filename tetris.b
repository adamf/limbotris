# "Tetris" by Adam W. Fletcher (adamf@csh.rit.edu)
#
# Moral support: Luke Crawford (luke@csh.rit.edu)
#
# copyright 1997 Computer Science House, Rochester Institute Of Technology
# all rights reserved
#
# http://www.csh.rit.edu
#
# based on the NetBSD terminal tetris, by Chris Torek and Darren F. Provine
#
# NetBSD and NetBSD tetris are copyright The Regents of the University of
# California
#
# This software is provided "as is" with no promises or warranties. 
#
# use at your own risk. Not responsible for loss of job, life, virginity,
# happiness, siblings, friends, family or pets. 
#
implement Tetris;

include "tetris.m";

# the setup_shapes() routine is in this file.
include "shapes.b";

timer(time_chan_send, time_chan_receive: chan of string)
{
    # Tell the main program to drop a shape.
    # this is my first foray into the world of limbo channels (this is
    # my first foray into limbo) and i think i'm using them in the 
    # 'channel' sense (IPC).. 
    # the timer is spawned off with a channel to recieve commands and
    # a channel to send commands. When the timer gets a "StartTimer", it
    # sleeps for that interval and then send the main program a TimeOut
    # the main program deals with this and tells the timer to sleep again
    # or kill itself.
    for(;;) {
       alt { 
            s := <-time_chan_receive =>
                (n,l) := sys->tokenize(s, " \t");
                case hd l {
                    "KillTimer" =>
                        exit;
                    "StartTimer" =>
                        #sys->print("Timer %d\n", timeout);
                        sys->sleep(timeout);
                        time_chan_send <-= "TimeOut";
                }
       }
    }
}


does_it_fit(cell_y, cell_x : int, s : shape): int
{
    # check to see if the shape shape fits into the board,
    # by seeing if all the cells in shape shape at the current
    # x,y are off
    xx, yy : int;
    for(xx=0; xx < s.array_width; xx++) {
        for(yy=0; yy < s.array_hieght; yy++) {
            if((s.value[yy][xx] >= 1) && 
                (board[cell_y + (yy - 1)][cell_x + (xx - 1)] >= 1)) {
                    return 0;
            }
        }
    } 
    return 1;
}

place_shape(onoff: int, s : shape)
{
    # Turn on (or off) the cells in the shape of shape at the
    # current x,y on the board
    xx, yy : int;
    for(xx=0; xx < s.array_width; xx++) {
        for(yy=0; yy < s.array_hieght; yy++) {
            if (s.value[yy][xx] >= 1)
                board[cell_pos.y + (yy - 1)][cell_pos.x + (xx - 1)] = onoff;
        }
    }
}

rm_line(t : ref Toplevel)
{
    # this is where the NetBSD tetris comes into play, as this
    # code is based off the elide() code in the NetBSD tetris
    # so all the respect goes out to them.
    #
    # rm_line() loops through every active row on the board
    # and walks across the row, looking for empty cells
    # if any cell is empty
    # go to the next row
    # otherwise, if no cells are empty, remove the line
    # update the score
    # and drop all the rows down to fit.
    xx, yy, z_count,x, j : int;
    
    for(yy=A_FIRST_ROW; yy < A_LAST_ROW + 1; yy++) {
    
        j=B_COLS - 2;
        for(x=0; board[yy][x] != 0 && x < A_LAST_COL;x++) {
            
            if((j--) <= 0) {
            
                for (z_count=A_FIRST_COL; z_count < A_LAST_COL; z_count++) {
                    board[yy][z_count] = 0;
                }
                
                score++;
                    
                # check to see if the level needs updating
                if (score == level * 20) level++;
                
                while ((yy--) != 1) {
                    for(xx=A_FIRST_COL; xx < A_LAST_COL; xx++) {
                        board[yy + 1][xx] = board[yy][xx];
                    }
                }
                
                update_screen(t);
            }
        }
    }
}

setup_board()
{
   # setup the off screen board edges to be 'on' so that pieces cannot
   # fall off the edge, and have a landing place along the bottom
   xx,yy : int;
   xx = 0;
   for(yy=B_ROWS - 1; yy>=0; yy--) {
       board[yy][xx] = 1;
       board[yy][xx + B_COLS - 1]= 1;
   }
   
   for(xx=B_COLS - 1; xx>=0; xx--)
       board[22][xx] = 1;
    
}
get_color(color_val : int) : string
{
    case color_val {
        1 =>
            return "red";
        2 =>
            return "blue";
        3 =>
            return "yellow";
        4 =>
            return "orange";
        5 =>
            return "white";
        6 =>
            return "gray";
        7 =>
            return "maroon";
    }
    # if shapes are black, things are bad.
    return "black";
}

update_screen(t : ref Toplevel)
{
   xx, yy : int;
   color : string;
   
   # clear all items on the canvas
   tk->cmd(t, ".bigframe.canvas delete all");
  
   # for every cell in the active board (active is the 'on screen' board)
   # check to see if there is an active block
   # if so, find it's color and plot it 
   for(xx=A_FIRST_COL; xx < A_LAST_COL; xx++) {
        for(yy=A_FIRST_ROW; yy <= A_LAST_ROW; yy++) {
        
            # convert the board coordinates to pixels on the screen
            (pixel_pos.x, pixel_pos.y) = cells_to_pixels(xx,yy);
            
            if(board[yy][xx] >= 1) {
                
                # turn the numerical coordinates in to a string, for
                # the tk command
                coords := sys->sprint("%d %d %d %d", 
                        pixel_pos.x, pixel_pos.y, pixel_pos.x + BLOCKSIZE, pixel_pos.y + BLOCKSIZE);
                tk->cmd(t, ".bigframe.canvas create rectangle " + coords + 
                        " -outline black -fill "+ get_color(board[yy][xx]) + " -width 1");
            } 
        }
    }
#    sys->print("Score: %d\n",score);
    s_string := sys->sprint("%d", score);
    tk->cmd(t, "label .bigframe.bottom_frame.label -text {Score: " +
        s_string + "} -background white");
    tk->cmd(t, "update");
    
    
}


cells_to_pixels(x: cell, y: cell) : (int, int)
{
    pix_x, pix_y : int;
    
    # convert board coordinates to pixel coordinates
    # subtract one from the cell coordinates to account for the
    # off screen edges, and multiply by the constant blocksize
    
    x -= 1;
    y -= 1;
    pix_x = x * BLOCKSIZE;
    pix_y = y * BLOCKSIZE;
    return (pix_x, pix_y);
}

new_shape(): shape
{
    rand_val : int;
    
    # get a new shape for the board, by picking a shape at 'random'
    # from the array of shapes
    # place the shape at the top of the board
    # if the shape won't fit at the top, the game is over.
    
    rand_val = rand->rand(7);
    
    if(does_it_fit(2,5,shapes[rand_val]) == 0) {
        game_over();
    } 
    
    cell_pos.x = 5;
    cell_pos.y = 2;
    
    return shapes[rand_val];
}

can_it_fall() : int
{
    # see if a piece can move down from its current position
    # this is used to see if a piece should be placed permenatly
    # on the board
   
    # turn off the current shape location. If the location is turned off
    # the shape will never fit 
    place_shape(0, curr_shape); 
    
    if (does_it_fit(cell_pos.y + 1, cell_pos.x, curr_shape) == 1) {
        return 0;
        place_shape(curr_shape.color, curr_shape);
    }
    
    place_shape(curr_shape.color, curr_shape);
    return 1;
}

game_over()
{
    # end the game
    # record the high scores
}

init(ctxt: ref Draw->Context, argv: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    tk = load Tk Tk->PATH;
    wmlib = load Wmlib Wmlib->PATH;
    rand = load Rand Rand->PATH;
    cant_fall : int;
    
    
    wmlib->init();
    
    
    # The channels. t is the tk channel, for sending to tk 
    # menubutton handles all of the wm events
    # cmd is the channel to send tk events back to the program
    # time_chan_send handles sending any messages to the timer,
    # such as kill and start
    # time_chan_recieve handles events back from the timer, such
    # as timeout
    
    t := tk->toplevel(ctxt.screen, "-borderwidth 2 -relief raised");
    menubutton := wmlib->titlebar(t, "Tetris", Wmlib->Appl);
    cmd := chan of string;
    time_chan_receive := chan of string;
    time_chan_send := chan of string;
    
    # establish the wm window and tk widgets, and setup the event channels 
    tk->namechan(t, cmd, "cmd");
    tk->cmd(t, "frame .bigframe -height 440 -width 300");
    tk->cmd(t, "canvas .bigframe.canvas -height "+ string BOARD_HEIGHT + 
                    " -width " + string BOARD_WIDTH + " -background green");
    tk->cmd(t, "frame .bigframe.bottom_frame");
    tk->cmd(t, "frame .bigframe.next_shape_frame");
#    tk->cmd(t, "canvas .bigframe.next_shape_frame.canvas -height 80 -width 80 -background green");
#    tk->cmd(t, "label .bigframe.next_shape_frame.label -text {Next:} -background white");
#    tk->cmd(t, "pack .bigframe.next_shape_frame.label .bigframe.next_shape_frame.canvas" +
#                    " -side top -fill x -expand 1"); 
    tk->cmd(t, "bind .bigframe.canvas <Key-h> {send cmd MoveLeft}");
    tk->cmd(t, "bind .bigframe.canvas <Key-s> {send cmd SlowDrop}");
    tk->cmd(t, "bind .bigframe.canvas <Key-d> {send cmd Drop}");
    tk->cmd(t, "bind .bigframe.canvas <Key-k> {send cmd RotateNext}");
    tk->cmd(t, "bind .bigframe.canvas <Key-j> {send cmd RotatePrev}");
    tk->cmd(t, "bind .bigframe.canvas <Key-l> {send cmd MoveRight}");
    tk->cmd(t, "label .bigframe.bottom_frame.label -text {Tetris!} -background white");
    tk->cmd(t, "button .bigframe.bottom_frame.quit -text {Quit!} -command {send cmd Quit}");
    tk->cmd(t, "focus .bigframe.canvas");
    tk->cmd(t, "pack .bigframe.bottom_frame.label .bigframe.bottom_frame.quit -side left -fill x -expand 1");
    tk->cmd(t, "pack .bigframe.canvas .bigframe.bottom_frame -side top -fill x");
    
    
    tk->cmd(t, "pack .bigframe.next_shape_frame -side right  -fill x");
    tk->cmd(t, "pack .Wm_t .bigframe -side top -fill x");
    tk->cmd(t, "update");
    
    # setup the shapes and boards, and start a shape at the top. 
    setup_shapes();
    setup_board();
    
    score = 0; 
    curr_shape = new_shape();
    next_shape = new_shape();
    
    place_shape(curr_shape.color, curr_shape);
    cant_fall = 0;

    # timer stuff. setup the initial timeout, spawn off the timer and
    # send a command to start it.
    
    timeout = 1000;
    spawn timer(time_chan_receive,time_chan_send);
    time_chan_send <-= "StartTimer";
    
    # Run it all!
    # loop, checking the channels for events
    # if a key is pressed, move the block that direction
    # or rotate it
    # if a timer event happens, move the block down if possible
    # if the block has tried to go down before and fails again,
    # place the block and get a new one
    # if the Quit button is pushed, clear the timer channel, send
    # a kill to the timer, and exit the program
    
    for (;;) {
        alt {
            s := <-cmd =>
                (n,l) := sys->tokenize(s, " \t");
                case hd l {
                    "Quit" =>
                        for(;;) {
                            alt {
                                time_out := <-time_chan_receive=>
                                    time_chan_send <-= "KillTimer"; 
                                    exit;
                            }
                        }
                    "MoveLeft" =>
                        place_shape(0, curr_shape); 
                        if (does_it_fit(cell_pos.y, cell_pos.x - 1, curr_shape) == 1) {
                            cell_pos.x -= 1;
                            place_shape(curr_shape.color, curr_shape);
                            update_screen(t);
                            cant_fall = can_it_fall();
                        } else 
                            cant_fall = can_it_fall();
                    "MoveRight" =>
                        place_shape(0, curr_shape); 
                        if (does_it_fit(cell_pos.y, cell_pos.x + 1, curr_shape) == 1) {
                            cell_pos.x += 1;
                            place_shape(curr_shape.color, curr_shape);
                            update_screen(t);
                            cant_fall = can_it_fall();
                        } else 
                            cant_fall = can_it_fall();
                    "RotateNext" =>
                        place_shape(0, curr_shape); 
                        if(does_it_fit(cell_pos.y,cell_pos.x, 
                                shapes[curr_shape.next_shape]) == 1) {
                            curr_shape = shapes[curr_shape.next_shape];
                            place_shape(curr_shape.color,curr_shape);
                            update_screen(t);
                            cant_fall = can_it_fall();
                        } else 
                            cant_fall = can_it_fall();
                    "RotatePrev" =>
                        place_shape(0, curr_shape); 
                        if(does_it_fit(cell_pos.y,cell_pos.x, 
                                shapes[curr_shape.prev_shape]) == 1) {
                            curr_shape = shapes[curr_shape.prev_shape];
                            place_shape(curr_shape.color,curr_shape);
                            update_screen(t);
                            cant_fall = can_it_fall();
                        } else 
                            cant_fall = can_it_fall();
                   "SlowDrop" =>
                        place_shape(0,curr_shape);
                        if (does_it_fit(cell_pos.y + 1, cell_pos.x, curr_shape) == 1) {
                            cell_pos.y += 1;
                            place_shape(curr_shape.color, curr_shape);
                            update_screen(t);
                            cant_fall = can_it_fall();
                        } else {
                            place_shape(curr_shape.color, curr_shape); 
                            cant_fall = 1;
                        }
                    "Drop" =>
                        for(;;) {
                            place_shape(0,curr_shape);
                            if (does_it_fit(cell_pos.y + 1, cell_pos.x, curr_shape) == 1) {
                                cell_pos.y += 1;
                                place_shape(curr_shape.color, curr_shape);
                            }  else {
                                cant_fall = 1;
                                place_shape(curr_shape.color,curr_shape);
                                break;
                            }
                        }
                        update_screen(t);
                            
                }
            menu := <-menubutton =>
                wmlib->titlectl(t, menu);
                
            time_out := <-time_chan_receive=>
                time_chan_send <-= "StartTimer";
                
                if(cant_fall == 1) {
                    rm_line(t);
                    curr_shape = next_shape;
                    next_shape = new_shape();
                    place_shape(curr_shape.color, curr_shape);
                    tk->cmd(t,"update"); 
                    cant_fall = 0;
                } else {
                    place_shape(0, curr_shape); 
                    if (does_it_fit(cell_pos.y + 1, cell_pos.x, curr_shape)  == 1) {
                        cell_pos.y += 1;
                        place_shape(curr_shape.color, curr_shape);
                        update_screen(t);
                        cant_fall = can_it_fall();
                    } else {
                        cant_fall = 1;
                        place_shape(curr_shape.color, curr_shape); 
                    }
                }
        }
    }
    
}


