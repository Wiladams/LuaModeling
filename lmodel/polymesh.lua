-- polymesh.lua
--[[
	Representation of a polygon mesh
]]

local PolyMesh = {}
setmetatable(PolyMesh, {
	__call = function(self, ...)
		return self:new(...)
	end;
})
local PolyMesh_mt = {
	__index = PolyMesh;
}


function PolyMesh.new(self, obj)
	obj = obj or {}		-- create object if user does not provide one

	obj.vertices = obj.vertices or {}
	obj.edges = obj.edges or {}
	obj.faces= obj.faces or {}

	setmetatable(obj, PolyMesh_mt)

	return obj
end

function PolyMesh:Vertices()
	return self.vertices
end

function PolyMesh:Faces()
	return self.faces
end

-- Add a vertex to the mesh
function PolyMesh.addvertex(self, v)
	table.insert(self.vertices, v)
	return #self.vertices;
end

function PolyMesh.addvertices(self, verts)
	for i,v in ipairs(verts) do
		table.insert(self.vertices, v)
	end

	return #self.vertices;
end

-- Add a face to the mesh
function PolyMesh.addface(self, f)
	table.insert(self.faces, f)
	return #self.faces;
end

function PolyMesh.addedge(self, v1, v2, f1, f2)
	table.insert(self.edges, {v1,v2,f1, f2})
	return #self.edges;
end


return PolyMesh