+===========================================================================
+
+ gCode - Vectric machine output post-processor for vCarve and Aspire
+
+===========================================================================
+
+ History
+
+ Who       When       What
+ ========  ========== =====================================================
+ EdwardW   01/13/2020 Initial authoring
+                      Added status messages (M117)
+                      Enabled Arc movements (G2/G3)
+                      Added ending presentation
+ EdwardW   02/28/2020
+                      Added G54 (CNC) coordinate support
+ EdwardW   10/26/2021
+                      Added router control (M3/M5)
+                      Switch to G53 (Machine Coords) during end script
+                      Removed tool change support because its unworkable
+===========================================================================

POST_NAME = "Marlin M0 G54 Arc (mm) (*.gcode)"

FILE_EXTENSION = "gcode"

UNITS = "MM"

+---------------------------------------------------------------------------
+    Configurable items based on your CNC
+---------------------------------------------------------------------------
+ Use 1-100 for spindle speeds instead of true speeds of 10000-27500
SPINDLE_SPEED_RANGE = 1 100 10000 27500

+ Replace all () with {} to avoid gCode interpretation errors
SUBSTITUTE = "(<)>"

+---------------------------------------------------------------------------
+    Line terminating characters
+---------------------------------------------------------------------------
+ Use windows-based line endings \r\n
LINE_ENDING = "[13][10]"

+---------------------------------------------------------------------------
+    Block numbering
+---------------------------------------------------------------------------
LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 1
LINE_NUMBER_MAXIMUM = 999999

+===========================================================================
+
+    Formatting for variables
+
+===========================================================================

VAR LINE_NUMBER = [N|A|N|1.0]
VAR SPINDLE_SPEED = [S|A|S|1.0]
VAR FEED_RATE = [F|C|F|1.1]
VAR CUT_RATE = [FC|C|F|1.1]
VAR PLUNGE_RATE = [FP|C|F|1.1]
VAR X_POSITION = [X|C|X|1.3]
VAR Y_POSITION = [Y|C|Y|1.3]
VAR Z_POSITION = [Z|C|Z|1.3]
VAR ARC_CENTRE_I_INC_POSITION = [I|A|I|1.3]
VAR ARC_CENTRE_J_INC_POSITION = [J|A|J|1.3]
VAR X_HOME_POSITION = [XH|A|X|1.3]
VAR Y_HOME_POSITION = [YH|A|Y|1.3]
VAR Z_HOME_POSITION = [ZH|A|Z|1.3]
VAR X_LENGTH = [XLENGTH|A|W:|1.0]
VAR Y_LENGTH = [YLENGTH|A|H:|1.0]
VAR Z_LENGTH = [ZLENGTH|A|Z:|1.1]

+===========================================================================
+
+    Block definitions for toolpath output
+
+===========================================================================

+---------------------------------------------------------------------------
+  Commands output at the start of the file
+---------------------------------------------------------------------------

begin HEADER

"; [TP_FILENAME]"
"; Generated [DATE] [TIME]"
"; Material size: [XLENGTH] [YLENGTH] [ZLENGTH] [UNITS]"
"; Safe Z height: [SAFEZ] mm"
"; Tools: [TOOLS_USED]"
"; Notes: [FILE_NOTES]"
"G90"
"G21"
"M117 [XLENGTH] [YLENGTH] [ZLENGTH] [UNITS] w/#[T] [TOOLNAME] @ [S]%"
"M0 Continue when ready"
"G54"
"G0 Z[SAFEZ] [F]"
"G0 [XH] [YH] [F]"
"M3 [S]"
"; Tool [T]: [TOOLNAME]"
"; Path: [TOOLPATH_NAME]"
"; [TOOLPATH_NOTES]"

+---------------------------------------------------------------------------
+  Commands output for rapid moves
+---------------------------------------------------------------------------

begin RAPID_MOVE

"G0 [X] [Y] [Z] [F]"

+---------------------------------------------------------------------------
+  Commands output for feed rate moves
+---------------------------------------------------------------------------

begin FEED_MOVE

"G1 [X] [Y] [Z] [FC]"

+---------------------------------------------------------------------------
+ Commands output for Plunge Moves
+---------------------------------------------------------------------------
begin PLUNGE_MOVE

"G1 [X] [Y] [Z] [FP]"

+---------------------------------------------------------------------------
+  Commands output for clockwise arc  move
+---------------------------------------------------------------------------

begin CW_ARC_MOVE

"G2 [X] [Y] [I] [J] [FC]"

+---------------------------------------------------------------------------
+  Commands output for counterclockwise arc  move
+---------------------------------------------------------------------------

begin CCW_ARC_MOVE

"G3 [X] [Y] [I] [J] [FC]"

+---------------------------------------------------------------------------
+  Commands output for toolpath changes
+---------------------------------------------------------------------------

begin NEW_SEGMENT

"; Path: [TOOLPATH_NAME] [PATHNAME]"
"; [TOOLPATH_NOTES]"
"M117 [TOOLPATH_NAME] @ [S]%"
"M3 [S]"

+---------------------------------------------------------------------------
+  Commands output at the end of the file
+---------------------------------------------------------------------------

begin FOOTER

"M5"
"M117 Returning home"
"G0 [ZH] [F]"
"G0 [XH] [YH] [F]"
"M117 Routing complete."
