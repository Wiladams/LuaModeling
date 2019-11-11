
local radians, degrees = math.rad, math.deg
local sin, cos = math.sin, math.cos
local maths = require("lmodel.maths")
local vec4_mult_mat4 = maths.vec4_mult_mat4
local mat4_mult_mat4 = maths.mat4_mult_mat4

--[[
	Perform transformations in 3D space
	identity
	translate
	scale
	rotate (x, y, z)
]]
local Transformer = {}
setmetatable(Transformer, {
	__call = function(self, ...)
		return self:new(...)
	end;
})
local Transformer_mt = {
	__index = Transformer;
	__tostring = function(self)
	end;
}

function Transformer.new(self, obj)
	-- start with identity transform if none specified
	obj = obj or {
		CurrentTransform = maths.mat4_identity();
	}
	
	obj.CurrentTransform = obj.CurrentTransform or maths.mat4_identity();
	
	setmetatable(obj, Transformer_mt)

	return obj
end

function Transformer.applyTransform(self, m)
	local m1 = mat4_mult_mat4(m, self.CurrentTransform)
	self.CurrentTransform = m1

	return self
end

function Transformer.translate(self, dx, dy, dz)
	dx = dx or 0
	dy = dy or 0
	dz = dz or 0

	local t = maths.mat4_translation(dx, dy, dz)
	return self:applyTransform(t)
end

function Transformer.scale(self, sx, sy, sz)
	local t = maths.mat4_scale(sx, sy, sz)
	return self:applyTransform(t)
end

function Transformer.rotate(self, rx, ry, rz)
	-- apply them in order
	local m1 = maths.mat4_rotx(rx)
	local m2 = maths.mat4_rotx(ry)
	local m3 = maths.mat4_rotz(rz)

	self:applyTransform(m1)
	self:applyTransform(m2)
	self:applyTransform(m3)

	return self
end

-- Apply accumulated transform to a point
function Transformer.transformCoordinates(self, x, y, z)
	return vec4_mult_mat4({x,y,z,1}, self.CurrentTransform)
end

function Transformer.transformPoint(self, pt)
	return vec4_mult_mat4({pt[1], pt[2], pt[3], 1}, self.CurrentTransform)
end

--
-- Function: Iter_matm4_mult_mat4
--
-- Description: Given a matrix of homogenized input
--	points, multiply then by the transform matrix, and
--	return them one by one as an iterator.
function Transformer.transformedPoints(self, m4)
	local function gen(param, row)
		if row > #param.points then	-- If we've run out of rows
			return nil;		-- we are done
		else
			local v = param.points[row]
			local vh = {v[1], v[2], v[3], 1}
			return row+1, vec4_mult_mat4(vh, param.transform);
		end
	end

	return gen, {points = m4, transform=self.CurrentTransform}, 1
end






return Transformer

