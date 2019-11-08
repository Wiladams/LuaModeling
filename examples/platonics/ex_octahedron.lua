package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local t = platonics.Octahedron({radius = 20});

local f = assert(io.open("octahedron.scad", 'w'));
oscad.PolyMesh_print(f,t:getMesh())
f:close()