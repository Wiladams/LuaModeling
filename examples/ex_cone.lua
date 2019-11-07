package.path = "../?.lua;"..package.path

local cone = require("lmodel.cone")
local oscad = require "lmodel.openscad_print"

-- Create shape file
local f = assert(io.open("output/test_cone.scad", 'w'));


local c1 = cone {
    anglesteps = 30;
    baseradius = 50;
    topradius = 0;
    height=100
}

oscad.PolyMesh_print(f,c1:getMesh())