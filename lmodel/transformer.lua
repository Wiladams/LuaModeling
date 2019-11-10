
local radians, degrees = math.rad, math.deg
local sin, cos = math.sin, math.cos
local maths = require("lmodel.maths")

--[[
	Perform transformations in 3D space
	identity
	translate
	scale
	rotate (x, y, z)
]]
local Transformer = {}
local Transformer_mt = {
	__index = Transformer;
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

function Transformer.transformCoordinates(self, x, y, z)
	return vec4_mult_mat4({x,y,z,1}, self.CurrentTransform)
end






--	Rotation
function transform_rotx(deg)
	local rad = radians(deg);
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{1, 0, 0, 0},
	{0, cosang, sinang, 0},
	{0, -sinang, cosang, 0},
	{0, 0, 0, 1}
	}
end
exports.rotx = transform_rotx

function  transform_roty(deg)
	local rad = radians(deg);
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, 0, -sinang, 0},
	{0, 1, 0, 0},
	{sinang, 0, cosang, 0},
	{0, 0, 0, 1}
	}
end
exports.roty = transform_roty

function  transform_rotz(deg)
	local rad = radians(deg);
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, sinang, 0, 0},
	{-sinang, cosang, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end
exports.rotz = transform_rotz



return Transformer

