-- polymesh.lua
--[[
	Representation of a polygon mesh
]]
local glsl = require("lmodel.glsl")

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
		self:addvertex(v)
	end

	return #self.vertices;
end

--[[
	The 'f' represents an array of vertex indices (1,2,3)
	These vertex indices are used to get the actual vertex
	from the array of vertices.
]]
-- Add a face to the mesh
function PolyMesh.addface(self, f)
	-- BUGBUG - we want to calculate the face normal
	-- right here so we don't have to calculate it later
	local p0 = self.vertices[face[1]];
	local p1 = self.vertices[face[2]];
	local p2 = self.vertices[face[3]];

	local v1 = glsl.sub(p0,p1);
	local v2 = glsl.sub(p2,p1);

	local norm = glsl.cross(v2, v1);

	face.normal = norm

	table.insert(self.faces, f)

	return #self.faces;
end

--  An edge is a connection between two points
function PolyMesh.addedge(self, v1, v2, f1, f2)
	table.insert(self.edges, {v1,v2,f1, f2})
	
	return #self.edges;
end


return PolyMesh