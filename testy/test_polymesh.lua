package.path = "../?.lua;"..package.path

local TriangleMesh = require ("lmodel.trimesh")
local oscad = require ("lmodel.openscad_print")

-- Construct a mesh
mesh = TriangleMesh:new()
mesh:addvertex({0,0,0})
mesh:addvertex({10,0,0})
mesh:addvertex({10,10,0})
mesh:addvertex({0, 10, 0})

print(mesh:addface({1,2,3}))
print(mesh:addface({1,3,4}))

local f = assert(io.open("output/test_TriangleMesh.scad", 'w'));

oscad.PolyMesh_print(f, mesh)

local Transformer = require("lmodel.Transformer")
local tform1 = Transformer()
tform1:translate(5,5, 3)
tform1:scale(1.5,2,1)
oscad.PolyMesh_print(f,mesh, tform1)

f:close()
