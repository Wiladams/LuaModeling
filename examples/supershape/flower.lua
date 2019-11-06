package.path = "../?.lua;../../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
-- mascot image
local f = assert(io.open("flower.scad", 'w'));

local shape1 = {n1=0.3, n2=0.3, n3=0.3, m=1.16667, a=1, b=1}
local shape2 = {n1=1, n2=1, n3=1, m=0, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 64, 64))