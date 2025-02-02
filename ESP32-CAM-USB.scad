//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for ESP32-CAM-USB (normal lens)
//
//  Version 1.0 (25-01-2022)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator_v11.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

baseWallHeight      = 16;
lidWallHeight       = 6;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 40;
pcbWidth            = 27.5;
pcbThickness        = 13.5; // both ESP32CAM and USB board
                            
// padding between pcb and inside wall
paddingFront        = 0.3;
paddingBack         = 0.3;
paddingRight        = 1.2;  // due to the RST switch
paddingLeft         = 1.2;  // due to the I00 switch

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 3.0;
roundRadius         = 2.0;

pinDiameter         = 0.5;  // no pin so hole can be as small as possible
standoffDiameter    = 3.5;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;

//-- D E B U G -------------------
showSideBySide      = true;
hideLidWalls        = false;
onLidGap            = 6;
shiftLid            = 10;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
inspectX            = 0;  // 0=none, >0 from front, <0 from back
inspectY            = 0;  // 0=none, >0 from left, <0 from right


//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [1,           1,          yappBoth, yappHole] 
               ,[1,  pcbWidth-1,          yappBoth, yappHole]
               ,[pcbLength-1, 1,          yappBoth, yappHole]
               ,[pcbLength-1, pcbWidth-1, yappBoth, yappHole]
             ];     

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLid =  [
                  [8,  ((pcbWidth/2)+0.5), 9, 20, yappCircle]       // lens
                , [8,  ((pcbWidth/2)+0.5), 9, 20, yappCircle]       // lens
                , [9,  ((pcbWidth/2)+0.5), 9, 20, yappCircle]       // lens
                , [10, ((pcbWidth/2)+0.5), 9, 20, yappCircle]       // lens
                , [30, pcbWidth-5, 6, 6, yappRectangle, yappCenter] // flash LED
              ];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBase =   [
                    [ 8, (pcbWidth/2),  7, 1.5, yappRectangle, yappCenter]
                  , [11, (pcbWidth/2), 10, 1.5, yappRectangle, yappCenter]
                  , [14, (pcbWidth/2), 12, 1.5, yappRectangle, yappCenter]
                  , [17, (pcbWidth/2), 14, 1.5, yappRectangle, yappCenter]
                  , [20, (pcbWidth/2), 16, 1.5, yappRectangle, yappCenter]
                  , [23, (pcbWidth/2), 16, 1.5, yappRectangle, yappCenter]
                  , [26, (pcbWidth/2), 14, 1.5, yappRectangle, yappCenter]
                  , [29, (pcbWidth/2), 12, 1.5, yappRectangle, yappCenter]
                  , [32, (pcbWidth/2), 10, 1.5, yappRectangle, yappCenter]
                  , [35, (pcbWidth/2),  7, 1.5, yappRectangle, yappCenter]
                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsFront =  [
                   [pcbWidth/2, -10, 12, 8, yappRectangle, yappCenter] // USB connector
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsBack =   [
                   [14, 1, 15, 6, yappRectangle, yappCenter] // SD slot
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsLeft =   [
                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = { yappRectangle | yappCircle }
// (5) = { yappCenter }
cutoutsRight =  [
                ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
connectors   =  [
                 //   [8, 8, 2.5, 3.8, 5, yappAllCorners]
                 // , [30, 8, 5, 5, 5]
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts   = [
               ];
               
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
labelsPlane =  [
               ];
               
//-------------------------------------------------------------
module baseHook()
{
  translate([(shellLength/2)-7.5,shellWidth-wallThickness,5])
  {
    difference()
    {
      union()
      {
        cube([15,10,10]);
        translate([0,10,5])
          rotate([0,90,0])
            cylinder(d=10, h=15);
      }
      translate([-1,10,5])
      {
        rotate([0,90,0])
          color("red") cylinder(d=4.5, h=17);
      }
      translate([5,0,-0.5])
        cube([5,16,11]);
    }
  
  } // translate
  
} //  baseHook()

//---- This is where the magic happens ----
YAPPgenerate();
