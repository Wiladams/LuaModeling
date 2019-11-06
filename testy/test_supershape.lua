package.path = "../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape.scad", 'w'));

local shape1 = {m=6.0, n1=60, n2=55, n3=1000, a=1, b=1}
local shape2 = {m=6, n1=250, n2=100, n3=100, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 64, 64))
