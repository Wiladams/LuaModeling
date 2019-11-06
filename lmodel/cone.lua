-- cone.lua
--
-- BanateCAD
-- Copyright (c) 2019  William Adams
--
-- Create the prototypical cone

local trimesh = require("lmodel.trimesh")
local glsl = require("lmodel.glsl")
local mix = glsl.mix
local cos = glsl.cos
local sin = glsl.sin
local PI = math.pi

local cone = {}
setmetatable(cone, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local cone_mt = {
    __index = cone
}

function cone.new(self, obj)
	obj = obj or {}		-- create object if user does not provide one

	obj.anglesteps = obj.anglesteps or 26
	obj.stacksteps = obj.stacksteps or 10
	obj.baseradius = obj.baseradius or 1
	obj.topradius = obj.topradius or 1
	obj.height = obj.height or 1

    setmetatable(obj, cone_mt)

    return obj
end

-- Returns a point on the surface given the angle and the position along the line
local function param_cone(u, lp1, lp2, angle)
	local p = {
		mix(lp1, lp2, u)[1]*cos(angle),
		mix(lp1, lp2, u)[1]*sin(angle),
		mix(lp1, lp2, u)[2]
		}

	return p
end

function cone.vindex(self, col, row)
	local index = row*(self.anglesteps+1) + col + 1
	return index;
end

function cone.triangle_faces_for_grid(self, width, height)
	local indices = {};
	local lastcol = width
	local lastrow = height

	for row =0, self.stacksteps-1 do
		local quadstrip = {};

		for col =0, self.anglesteps-1 do
			local tri1 = {self:vindex(col, row), self:vindex(col+1, row), self:vindex(col+1,row+1)}
			local tri2 = {self:vindex(col, row), self:vindex(col+1, row+1), self:vindex(col, row+1)}

			table.insert(indices, tri1)
			table.insert(indices, tri2)
		end
	end

	return indices;
end

function cone.getMesh(self)
	local lp1 = {self.baseradius,0, 0}
	local lp2 = {self.topradius, 0, self.height}

	local mesh = trimesh({name=self.name})
	local stepangle = 2*PI/self.anglesteps;

	for stack = 0, self.stacksteps do
		local v = stack/self.stacksteps
		for astep = 0, self.anglesteps do
			local terp = mix(lp1, lp2, v)
			local angle = astep * stepangle
			local p = {
				terp[1]*cos(angle),
				terp[1]*sin(angle),
				mix(lp1, lp2, v)[3],
			}

			mesh:addvertex(p)
		end
	end

	-- Now that we have all the vertices
	-- Add all the faces
	local indices = self:triangle_faces_for_grid(self.anglesteps, self.stacksteps);

	for i,v in ipairs(indices) do
		mesh:addface(v)
	end

	return mesh
end


return cone