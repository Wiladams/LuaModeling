require ("polymesh")
require ("openscad_print")

-- Construct a mesh
mesh = PolyMesh:new()
mesh:addvertex({0,0,0})
mesh:addvertex({10,0,0})
mesh:addvertex({10,10,0})
mesh:addvertex({0, 10, 0})

print(mesh:addface({1,2,3}))
print(mesh:addface({1,3,4}))

local f = assert(io.open("test_PolyMesh.scad", 'w'));

--print(mesh:Vertices())
PolyMesh_print(f, mesh)
