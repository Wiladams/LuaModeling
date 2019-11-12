
--[[
	Representation of a triangle mesh
]]
local glsl = require("lmodel.glsl")

local TriangleMesh = {}
setmetatable(TriangleMesh, {
	__call = function(self, ...)
		return self:new(...)
	end;
})
local TriangleMesh_mt = {
	__index = TriangleMesh;
}


function TriangleMesh.new(self, obj)
	obj = obj or {}		-- create object if user does not provide one

	obj.vertices = obj.vertices or {}
	obj.edges = obj.edges or {}
	obj.faces= obj.faces or {}

	setmetatable(obj, TriangleMesh_mt)

	return obj
end

function TriangleMesh:Vertices()
	return self.vertices
end

function TriangleMesh:Faces()
	return self.faces
end

-- Add a vertex to the mesh
function TriangleMesh.addvertex(self, v)
	table.insert(self.vertices, v)
	return #self.vertices;
end

function TriangleMesh.addvertices(self, verts)
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
function TriangleMesh.addface(self, face)

	-- we want to calculate the face normal
	-- right here so we don't have to calculate it later
	-- BUGBUG - it might be useful to store this in yet another array
	--   rather than altering the face object itself, because that may
	--   not be a mutable table.
	local p0 = self.vertices[face[1]];
	local p1 = self.vertices[face[2]];
	local p2 = self.vertices[face[3]];

	local v1 = glsl.sub(p0,p1);
	local v2 = glsl.sub(p2,p1);

	local norm = glsl.cross(v2, v1);

	face.normal = norm

	local faceidx = table.insert(self.faces, face)

	return #self.faces;
end

--  An edge is a connection between two points
function TriangleMesh.addedge(self, v1, v2, f1, f2)
	table.insert(self.edges, {v1,v2,f1, f2})
	
	return #self.edges;
end


return TriangleMesh