# wave.tcl: TCL script for GTKWave simulator with signal definitions 
# Author(s): Lukas Kekely (ikekely@fit.vutbr.cz)

gtkwave::/Edit/Insert_Comment "Main Interface"
gtkwave::addSignalsFromList [list clk rst]
gtkwave::addSignalsFromList [list din_state]
gtkwave::/Edit/Color_Format/Blue
gtkwave::addSignalsFromList [list DOUT_VLD DOUT DIN ]
gtkwave::/Edit/Insert_Blank

gtkwave::/Edit/Insert_Comment "Other Signals"
gtkwave::addSignalsFromList [list fsm_out MIDBIT ADDRESS_OUT counter]
         # <<< TODO: Insert 'gtkwave::addSignalsFromList' for your signals here.

gtkwave::/Edit/UnHighlight_All
gtkwave::/Time/Zoom/Zoom_Best_Fit
