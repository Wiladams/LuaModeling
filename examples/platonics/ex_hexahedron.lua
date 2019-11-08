package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local p = platonics.Hexahedron({radius = 20});

local f = assert(io.open("hexahedron.scad", 'w'));
oscad.PolyMesh_print(f,p:getMesh())
f:close()