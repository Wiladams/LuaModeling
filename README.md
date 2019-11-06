LuaModeling is a library of 3D modeling routines written using
the Lua language.

![supershape](images/supershape2.PNG?raw=true)

There are a number of techniques I want to use in 3D modeling.  My primary tool 
of choice is OpenSCAD.  I choose OpenSCAD because it's relatively easy to use from
a programmer's perspective.  It does not have a very robust graphical interface
for interacting with your models, rather it relies on code to do the modeling.

I find OpenSCAD to be a bit limiting in the language itself, but it has a 
polygon mesh object that it can render, so the approach taken in LuaModeling 
is to use Lua as the modeling engine, and just output polygon mesh objects to 
be rendered by OpenSCAD.

A good workflow is to create your models in LuaModeling, which will then 
generate an OpenSCAD file.  Then, open this file using OpenSCAD, and keep 
it open.  If you make changes to your original file, and generate the .scad 
file again, it will be automatically rendered, because OpenSCAD tracks changes
to source files, and automatically re-renders.

By doing things this way, you're free to experiment with modeling techniques
using Lua as your language, which is much faster and more flexible than OpenSCAD.

Usage
=====
Look at the various test cases for examples of what can be done.

As well as generating polygon mesh objects for OpenSCAD, you can generate a .stl file
directly from the mesh as well.  That makes it perfect for generating files for 
3D printing directly.

Examples
========
testy/test_mesh_lofting.lua  An example of attaching a height map to a mesh<br/>

![supershape](images/heightmap.PNG?raw=true)

testy/test_cone.lua  An example of a simple cone<br/>

![supershape](images/cone.PNG?raw=true)<br/>
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

![supershape](images/ellipsoid.PNG?raw=true)<br/>
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

![supershape](images/torus.PNG?raw=true)<br/>
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


TODO
====
* Remove more from global namespace
* Write more test cases
* Fix bugs
* Change objects to use named field instead of positions
* Add more parametric shapes
* add CSG operations
