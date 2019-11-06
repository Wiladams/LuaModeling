Some examples.  Look at the various codes within this directory.  Bring up a command line and execute the files directly using your lua interpreter.


testy/test_mesh_lofting.lua  An example of attaching a height map to a mesh<br/>

![heightmap](images/heightmap.PNG?raw=true)

testy/test_cone.lua  An example of a simple cone<br/>

![cone](images/cone.PNG?raw=true)<br/>
```lua
local cone = require("lmodel.cone")
local oscad = require "lmodel.openscad_print"

-- Create shape file
local f = assert(io.open("output/test_cone.scad", 'w'));

--  you can change these parameters to change
-- the shape of the cone
local c1 = cone {
    anglesteps = 30;
    baseradius = 50;
    topradius = 0;
    height=100
}

oscad.PolyMesh_print(f,c1:getMesh())
```


![supershape](images/ellipsoid.PNG?raw=true) - Creating a partial ellipsoid<br/>
```lua
local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local degrees = glsl.degrees
local radians = glsl.radians

local Ellipsoid = require("lmodel.ellipsoid")

-- Create shape file
local f = assert(io.open("output/test_ellipsoid.scad", 'w'));

local se = Ellipsoid {
    USteps = 10,
    WSteps = 10,
    XRadius = 60, 
    ZRadius = 10, 
    MaxTheta = radians(120), 
    MaxPhi = radians(180),
}

oscad.PolyMesh_print(f,se:getMesh())
```

![torus](images/toroid.PNG?raw=true) - Creating an open toroid<br/>
```lua
local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local degrees = glsl.degrees
local radians = glsl.radians

local Torus = require("lmodel.torus")

-- Create shape file
local f = assert(io.open("output/test_torus.scad", 'w'));


local shape = Torus {
    USteps = 60;
    WSteps = 60;
    HoleRadius = 10;
	ProfileRadius =  5;
	--ProfileSampler = obj.ProfileSampler

    -- change the amount of cross section
    MinTheta = 0;
    MaxTheta = radians(270);

    -- change the amount around the donut
    MinPhi = 10;
    MaxPhi = radians(320);
}

oscad.PolyMesh_print(f,shape:getMesh())
```