-- polymesh.lua

PolyMesh = {}

function PolyMesh:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	vertices = {}
	edges = {}
	faces={}

	return o
end


-- Add a vertex to the mesh
function PolyMesh:addvertex(v)
	table.insert(vertices, v)
	return #vertices;
end

function PolyMesh:addvertices(verts)
	for i,v in ipairs(verts) do
		table.insert(vertices, v)

	return #vertices;
end

-- Add a face to the mesh
function PolyMesh:addface(f)
	table.insert(faces, f)
end

function PolyMesh:addedge(v1, v2, f1, f2)
	table.insert(edges, {v1,v2,f1, f2})
	return #edges;
end





mesh = PolyMesh:new()
print(mesh:addvertex({0,0,0}))
print(mesh:addvertex({1,1,1}))

