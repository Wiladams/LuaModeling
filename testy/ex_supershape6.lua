package.path = "../?.lua;"..package.path

local sshape = require ("lmodel.supershape")
local oscad = require "lmodel.openscad_print"

-- Create a supershape
local f = assert(io.open("output/supershape6.scad", 'w'));

-- Snail shell Shape
-- m,n1,n2, n3, a, b
local shape1 = {n1=1.0, n2=1.0, n3=1.0, m=0.0, a=1.0, b=1.0}
local shape2 = {n1=1.0, n2=1.0, n3=1.0, m=0.0, a=1.0, b=1.0}
local mesh = sshape.getMesh(shape1, shape2, 32, 32)

oscad.PolyMesh_print(f,mesh)