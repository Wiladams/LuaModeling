# supershape

Described here: http://paulbourke.net/geometry/supershape/

The supershape formula was developed as a framework for creating
natural looking organic shapes.  The formula is derived from the
super ellipse, but for 3D space.

You can change various parameters to create very different shapes.
You can create classic shapes such as cubes and spheres, but  also
starfish, snail shells, and the like.

Experimentation is your friend here.  Read the Paul Bourke material
and try out various things.


[mascot](images/mascot.PNG)
```lua
local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
-- mascot image
local f = assert(io.open("mascot.scad", 'w'));

local shape1 = {m=6.0, n1=60, n2=55, n3=1000, a=1, b=1}
local shape2 = {m=6, n1=250, n2=100, n3=100, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 64, 64))
```

[cube]!(images/cube.PNG)
```lua
local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

local f = assert(io.open("cube.scad", 'w'));

local shape1 = {n1=100, n2=100, n3=100, m=4, a=1, b=1}
local shape2 = {n1=100, n2=100, n3=100, m=4, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 64, 64))
```

[diamond]!(images/diamond.PNG)
```lua
local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

local f = assert(io.open("diamond.scad", 'w'));

local shape1 = {n1=100, n2=1, n3=1, m=4, a=1, b=1}
local shape2 = {n1=1, n2=1, n3=1, m=4, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 4, 120))
```

[flower]!(images/flower.PNG?raw=true)
```lua
local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

local f = assert(io.open("flower.scad", 'w'));

local shape1 = {n1=0.3, n2=0.3, n3=0.3, m=1.16667, a=1, b=1}
local shape2 = {n1=1, n2=1, n3=1, m=0, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 64, 64))
```