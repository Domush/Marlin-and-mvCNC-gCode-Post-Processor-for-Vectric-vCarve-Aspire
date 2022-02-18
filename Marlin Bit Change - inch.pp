+===========================================================================
|
| gCode - Vectric machine output post-processor for vCarve and Aspire
|
+===========================================================================

POST_NAME = "Marlin w/Bit Change (inch) (*.gcode)"

FILE_EXTENSION = "gcode"

UNITS = "inches"

+---------------------------------------------------------------------------
|    Configurable items based on your CNC
+---------------------------------------------------------------------------
+ Use 1-100 (%) for spindle speeds instead of true speeds of 10000-27500 (rpm)
SPINDLE_SPEED_RANGE = 1 100 10000 27500

+ Replace all () with <> to avoid gCode interpretation errors
+ SUBSTITUTE = "([91])[93]"

+ Plunge moves to Plunge (Z2) height are rapid moves
RAPID_PLUNGE_TO_STARTZ = "YES"

+---------------------------------------------------------------------------
|    Line terminating characters
+---------------------------------------------------------------------------
+ Use windows-based line endings \r\n
+ LINE_ENDING = "[13][10]"

+ Use unix-based line endings \n
LINE_ENDING = "[10]"

+---------------------------------------------------------------------------
|    Block numbering
+---------------------------------------------------------------------------
LINE_NUMBER_START     = 0
LINE_NUMBER_INCREMENT = 1
LINE_NUMBER_MAXIMUM = 999999

+===========================================================================
|
|    Formatting for variables
|
+===========================================================================

VAR LINE_NUMBER = [N|A|N|1.0]
VAR SPINDLE_SPEED = [S|A|S|1.0]
VAR CUT_RATE = [FC|C|F|1.0]
VAR PLUNGE_RATE = [FP|C|F|1.0]
VAR X_POSITION = [X|C| X|1.4]
VAR Y_POSITION = [Y|C| Y|1.4]
VAR Z_POSITION = [Z|C| Z|1.4]
VAR ARC_CENTRE_I_INC_POSITION = [I|A| I|1.4]
VAR ARC_CENTRE_J_INC_POSITION = [J|A| J|1.4]
VAR X_HOME_POSITION = [XH|A| X|1.4]
VAR Y_HOME_POSITION = [YH|A| Y|1.4]
VAR Z_HOME_POSITION = [ZH|A| Z|1.4]
+ VAR X_LENGTH = [XLENGTH|A|W:|1.1]
+ VAR Y_LENGTH = [YLENGTH|A|H:|1.1]
+ VAR Z_LENGTH = [ZLENGTH|A|Z:|1.2]
VAR X_LENGTH = [XLENGTH|A||1.1]
VAR Y_LENGTH = [YLENGTH|A||1.1]
VAR Z_LENGTH = [ZLENGTH|A||1.2]
VAR Z_MIN = [ZMIN|A||1.2]
VAR SAFE_Z_HEIGHT = [SAFEZ|A||1.4]
VAR DWELL_TIME = [DWELL|A|S|1.2]


+===========================================================================
|
|    Block definitions for toolpath output
|
+===========================================================================

+---------------------------------------------------------------------------
|  Start of file output
+---------------------------------------------------------------------------
begin HEADER

"; Job name: [TP_FILENAME]"
"; Job size: [YLENGTH] x [XLENGTH] x [ZMIN]in"
"; Tools: [TOOLS_USED]"
"; Paths: [TOOLPATHS_OUTPUT]"
"; Safe Z: [SAFEZ]in"
"; Generated on [DATE] [TIME] by [PRODUCT]"
"M117 [YLENGTH]x[XLENGTH]x[ZMIN]in"
"G54"
"G92 X0 Y0 Z0"
"M300 S560 P550"
"M300 S260 P750"
"M300 S560 P550"
"M300 S260 P750"
"G90"
"G21"
"G0 X50 Y300 Z90 F8000"
"M117 Insert [TOOLNAME]"
"M117 !!CONNECT PROBE!!"
"M0 Insert [TOOLNAME] and *CONNECT PROBE*"
+ Set below XY to position of your Zero Plate (in mm)
"G0 X20 Y20 Z30"
"G91"
"G38.2 Z-40 F300"
"G0 Z3"
"G38.2 Z-5 F150"
+ Set below Z to height of your Zero Plate (in mm)
"G92 Z6.5"
"G0 Z20"
"M117 !!Remove probe!!"
"M0 *REMOVE PROBE*"
"G90"
"G20"
+ Manually set spindle to 100% since I have no VFD. Otherwise use: M3 [S]
"M3 S100"
";==========================================================================="
";"
";      Path: [TOOLPATH_NAME]"
";      Tool: #[T] : [TOOLNAME]"
";"
";==========================================================================="
"M117 [TOOLPATH_NAME] - Bit #[T]"

+---------------------------------------------------------------------------
|  Rapid (no load) move
+---------------------------------------------------------------------------
begin RAPID_MOVE

"G0 [X][Y][Z]"

+---------------------------------------------------------------------------
|  Carving move
+---------------------------------------------------------------------------
begin FEED_MOVE

"G1 [X][Y][Z] [FC]"

+---------------------------------------------------------------------------
|  Plunging move - Only enable if necessary. Can cause huge slowdowns
+---------------------------------------------------------------------------
begin PLUNGE_MOVE

"G1 [X][Y][Z] [FP]"

+---------------------------------------------------------------------------
|  Clockwise arc move
+---------------------------------------------------------------------------
begin CW_ARC_MOVE

"G2 [X][Y][I][J] [FC]"

+---------------------------------------------------------------------------
|  Counterclockwise arc move
+---------------------------------------------------------------------------
begin CCW_ARC_MOVE

"G3 [X][Y][I][J] [FC]"

+---------------------------------------------------
|  Clockwise helical-arc move
+---------------------------------------------------
begin CW_HELICAL_ARC_MOVE

"G2 [X][Y][Z][I][J] [FC]"

+---------------------------------------------------
|  Counterclockwise helical-arc move
+---------------------------------------------------
begin CCW_HELICAL_ARC_MOVE

"G3 [X][Y][Z][I][J] [FC]"

+---------------------------------------------------------------------------
|  Begin new toolpath
+---------------------------------------------------------------------------
begin NEW_SEGMENT

";==========================================================================="
";"
";      Path: [TOOLPATH_NAME]"
";"
";==========================================================================="
"M117 [TOOLPATH_NAME] - Bit #[T]"

+ Overriding to 100% since I have no VFD. Otherwise use M3 [S]
"M3 S100"

+---------------------------------------------------------------------------
|  Change bits (manually)
+---------------------------------------------------------------------------
begin TOOLCHANGE

";==========================================================================="
";"
";      Tool change: #[T] : [TOOLNAME]"
";      [TOOL_NOTES]"
";==========================================================================="
"M5"
"M117 Change Bit: #[T]"

"G4 S3"
"M300 S560 P550"
"M300 S260 P750"
"M300 S560 P550"
"M300 S260 P750"
"G21"
"G0 X50 Y300 Z90"
"M117 Insert [TOOLNAME]"
"M117 !!CONNECT PROBE!!"
"M0 Insert [TOOLNAME] and *CONNECT PROBE*"
+ Set below XY to position of your Zero Plate (in mm)
"G0 X20 Y20 Z30"
"G91"
"G38.2 Z-40 F300"
"G0 Z3"
"G38.2 Z-5 F150"
+ Set below Z to height of your Zero Plate (in mm)
"G92 Z6.5"
"G0 Z20"
"M117 !!Remove probe!!"
"M0 *REMOVE PROBE*"
"G90"
"G20"

+---------------------------------------------
+  Dwell (momentary pause)
+---------------------------------------------
begin DWELL_MOVE

"G4 [DWELL]"

+---------------------------------------------------------------------------
|  End of file output
+---------------------------------------------------------------------------
begin FOOTER

"G0 Z2"
"M117 Returning home"
"M5"
"G4 S3"
"G53"
"G0 X0 Y0 Z110"
"G21"
"M117 Routing complete."
