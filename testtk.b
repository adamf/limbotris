implement test_tk;

include "testtk.m";



init(ctxt: ref Draw->Context, argv: list of string)
{
    sys = load Sys Sys->PATH;
    draw = load Draw Draw->PATH;
    tk = load Tk Tk->PATH;
    wmlib = load Wmlib Wmlib->PATH;
    
    
    wmlib->init();
    
    
    
    t := tk->toplevel(ctxt.screen, "-borderwidth 2 -relief raised");
    menubutton := wmlib->titlebar(t, "Tetris", Wmlib->Appl);
    cmd := chan of string;
    
    # establish the wm window and tk widgets, and setup the event channels 
    tk->namechan(t, cmd, "cmd");
    tk->cmd(t, "frame .bigframe -height 440 -width 300");
    tk->cmd(t, "canvas .bigframe.canvas -height "+ string 300 + 
                    " -width " + string 200 + " -background green");
    tk->cmd(t, "frame .bigframe.bottom_frame");
    tk->cmd(t, "frame .bigframe.next_shape_frame");
    tk->cmd(t, "canvas .bigframe.next_shape_frame.canvas -height 80 -width 80 -background green");
    tk->cmd(t, "label .bigframe.next_shape_frame.label -text {Next:} -background white");
    tk->cmd(t, "pack .bigframe.next_shape_frame.label .bigframe.next_shape_frame.canvas" +
                    " -side top -fill x -expand 1"); 
    tk->cmd(t, "label .bigframe.bottom_frame.label -text {Tetris!} -background white");
    tk->cmd(t, "button .bigframe.bottom_frame.quit -text {Quit!} -command {send cmd Quit}");
    tk->cmd(t, "focus .bigframe.canvas");
    tk->cmd(t, "pack .bigframe.bottom_frame.label .bigframe.bottom_frame.quit -side left -fill x -expand 1");
    tk->cmd(t, "pack .bigframe.canvas .bigframe.bottom_frame -side top -fill x");
    
    
    tk->cmd(t, "pack .bigframe.next_shape_frame -side right  -fill x");
    tk->cmd(t, "pack .Wm_t .bigframe -side top -fill x");
    tk->cmd(t, "update");
    
}


