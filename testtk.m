
include "sys.m";
include "draw.m";
include "tk.m";
include "wmlib.m";

sys : Sys;
draw : Draw;
tk : Tk;
wmlib : Wmlib;
   
Toplevel: import Tk;  
FD : import Sys;

test_tk: module
{
   init: fn(ctxt: ref Draw->Context, argv: list of string);
   #test_tk: fn();
};

