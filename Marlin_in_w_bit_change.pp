+===========================================================================
|
| gCode - Vectric machine output post-processor for vCarve and Aspire
|
+===========================================================================
|
| History
|
| Who       When       What
| ========  ========== =====================================================
| EdwardW   01/13/2020 Initial authoring
|                      Added status messages (M117)
|                      Enabled Arc movements (G2/G3)
|                      Added ending presentation
| EdwardW   02/28/2020
|                      Added G54 (CNC) coordinate support
| EdwardW   10/26/2021
|                      Added router control (M3/M5)
| EdwardW   12/14/2021
|                      Added helical-arc support
|                      Changed to unix line endings
|                      Improved comments
|                      Increased plunge speed when above material
|                      Now uses machine default rapid move speed
|                      Disabled PLUNGE_RATE section to avoid slowdowns
|                      Comments now report carved Z depth, not material Z
| EdwardW   1/22/2022
|                      Added manual bit change support
|                      !!Be sure to edit bit change defaults for Zero Probe!
|                      Zero Probe default Z-height: 6.5mm
|                      Fixed metric file to correctly set to metric
+===========================================================================

POST_NAME = "Marlin G54 Bit Change (in) (*.gcode)"

FILE_EXTENSION = "gcode"

UNITS = "inches"

+---------------------------------------------------------------------------
|    Configurable items based on your CNC
+---------------------------------------------------------------------------
+ Use 1-100 (%) for spindle speeds instead of true speeds of 10000-27500 (rpm)
SPINDLE_SPEED_RANGE = 1 100 10000 27500

+ Replace all <> with () to avoid gCode interpretation errors
SUBSTITUTE = "([91])[93]"

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

"; [TP_FILENAME]"
"; Material size: [YLENGTH] x [XLENGTH] x [ZMIN][34]"
"; Tools: [TOOLS_USED]"
"; Paths: [TOOLPATHS_OUTPUT]"
"; Safe Z: [SAFEZ][34]"
"; Generated on [DATE] [TIME] by [PRODUCT]"
"G90"
"G20"
"M117 [YLENGTH][34]x[XLENGTH][34]x[ZMIN][34]  Bit #[T]"
"M0 Load [TOOLNAME]"
"G54"
"G0 Z[SAFEZ]"
"G0 [XH][YH]"
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
+begin PLUNGE_MOVE

+"G1 [X][Y][Z] [FP]"

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

"M300 S660 P350"
"M300 S460 P350"
"M300 S660 P350"
"M300 S460 P350"
"G21"
"G53 G0 Z100"
"G53 G0 X0 Y200"
"M0 Bit: [TOOLNAME]"
"G0 Z80"
+ Set below XY to position to probe your Zero Plate (in mm)
"G0 X20 Y20"
"M0 Connect probe"
"G91"
"G38.2 Z-40 F200"
"G0 Z3"
"G38.2 Z-6 F100"
+ Set below Z to height of your Zero Plate (in mm)
"G92 Z6.5"
"G0 Z10"
"M0 Remove probe"
"G90"
"G20"
"G0 Z[SAFEZ]"
"G0 [XH][YH]"

+---------------------------------------------
+  Dwell (momentary pause)
+---------------------------------------------
begin DWELL_MOVE

"G4 [DWELL]"

+---------------------------------------------------------------------------
|  End of file output
+---------------------------------------------------------------------------
begin FOOTER

"M5"
"M117 Returning home"
"G0 [ZH]"
"G0 [XH][YH]"
"M117 Routing complete."
