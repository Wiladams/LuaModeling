Some examples.  Look at the various codes within this directory.  Bring up a command line and execute the files directly using your lua interpreter.  You will see a '.scad' file in the output directory.  Open that up with OpenSCAD and view the thing in question.  You can leave the OpenSCAD program open, play with parameters in the '.lua' file, rerun the program, and the OpenSCAD view will automatically change.<br/>


examples/ex_metaball - metaball with 3 ball influence<br/>
![metaball](images/metaball.PNG?raw=true)

```lua
package.path = "../?.lua;"..package.path

local oscad = require "lmodel.openscad_print"
local glsl = require("lmodel.glsl")
local metaball = require("lmodel.metaball")

-- Create shape file
local f = assert(io.open("output/metaball.scad", 'w'));

-- each ball specified a center, and a radius
local balls = {
    {15, 15, 0, 5}, 
    {30, 15, 0, 5}, 
    {20, 40, 0, 5}}

local s = metaball:new({
    USteps = 60;    -- steps around latitude
    WSteps = 30;    -- steps around longitude
    balls = balls;
})

oscad.PolyMesh_print(f,s:getMesh())

f:close()
```


examples/ex_cone.lua  An example of a simple cone<br/>
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


examples/ex_ellipsoid - Creating a partial ellipsoid<br/>

![supershape](images/ellipsoid.PNG?raw=true)

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

Creating an open toroid<br/>
![torus](images/toroid.PNG?raw=true)

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

testy/test_mesh_lofting.lua  An example of attaching a height map to a mesh<br/>

![heightmap](images/heightmap.PNG?raw=true)

