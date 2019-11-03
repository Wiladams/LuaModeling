package.path = "../?.lua;"..package.path

local polymesh = require ("lmodel.polymesh")
local oscad = require ("lmodel.openscad_print")

-- Construct a mesh
mesh = PolyMesh:new()
mesh:addvertex({0,0,0})
mesh:addvertex({10,0,0})
mesh:addvertex({10,10,0})
mesh:addvertex({0, 10, 0})

print(mesh:addface({1,2,3}))
print(mesh:addface({1,3,4}))

local f = assert(io.open("output/test_PolyMesh.scad", 'w'));

--print(mesh:Vertices())
PolyMesh_print(f, mesh)
