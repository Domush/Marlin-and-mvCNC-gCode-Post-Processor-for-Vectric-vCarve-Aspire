# Marlin G-code Postprocessor
## For Vectric vCarve, Aspire 9, 9.5, 10, 10.5 and 11
 
Turns your Aspire and v-carve sketches into gcode for Marlin 2.x CNC control boards. 
 
## Features:
- Both metric (mm) and imperial (inches) versions
- gCode files are saved using a .gcode extension (the Marlin default)
- In-line manual bit change support (separate bit change branch)

## Assumptions:
- Your machine supports M3/M5 (spindle control)
- CNC coord system enabled in Marlin config
- (Edit the .pp and remove those lines if yours does not support the above)

**Be sure to edit the .pp files and check the configuration against your needs/machine support.**

Cheers,
Edward Webber
