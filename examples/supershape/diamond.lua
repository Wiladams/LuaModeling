package.path = "../?.lua;../../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
-- cube image
local f = assert(io.open("diamond.scad", 'w'));

local shape1 = {n1=100, n2=1, n3=1, m=4, a=1, b=1}
local shape2 = {n1=1, n2=1, n3=1, m=4, a=1, b=1}

oscad.PolyMesh_print(f,sshape.getMesh(shape1, shape2, 4, 120))