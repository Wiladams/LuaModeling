-- torus.lua
--
-- BanateCAD
-- Copyright (c) 2019  William Adams
--

local BiParametric = require ("lmodel.BiParametric")
local glsl = require("lmodel.glsl")
local cos, sin = glsl.cos, glsl.sin

-- Offset
-- Size
local function alerp( a1, a2, u)
	return a1 + u*(a2-a1)
end


local Torus = {}
setmetatable(Torus, {
    __index = BiParametric;
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Torus_mt = {
    __index = Torus
}

function Torus.new(self, obj)
    obj = BiParametric(obj)

	obj.HoleRadius = obj.HoleRadius or 1
	obj.ProfileRadius = obj.ProfileRadius or 1
	obj.ProfileSampler = obj.ProfileSampler or nil

	obj.MinTheta = obj.MinTheta or 0
	obj.MaxTheta = obj.MaxTheta or 2*math.pi
	obj.MinPhi = obj.MinPhi or 0
	obj.MaxPhi = obj.MaxPhi or 2*math.pi

    setmetatable(obj, Torus_mt)

    return obj
end


-- Should be an x,z value
function Torus.getProfileVertex(self, u)

	local thetaangle = alerp(self.MinTheta, self.MaxTheta, u)
	u = thetaangle/self.MaxTheta

	if self.ProfileSampler ~= nil then
		-- Get the profile
		local profilept = self.ProfileSampler:GetProfileVertex(u)

		-- Add the appropriate offset
		local x = self.HoleRadius+profilept[1]
		local y = self.HoleRadius+profilept[2]
		local z = profilept[3]

		return {x,y,z}
	end

	-- If we don't have a profile generator
	-- Assume the profile should be a sphere
	local angle = alerp(self.MinTheta, self.MaxTheta, u)
	local x = (self.HoleRadius+self.ProfileRadius*sin(angle))
	local y = (self.HoleRadius+self.ProfileRadius*sin(angle))
	local z = self.ProfileRadius*cos(angle)

	return {x,y,z}
end

function Torus.getVertex(self, u, v)
	local phi = alerp(self.MinPhi, self.MaxPhi, v)


	local profilept, normal = self:getProfileVertex(u)

	local x = profilept[1]*cos(phi)
	local y = profilept[2]*sin(phi)
	local z = profilept[3]

	local pt = {x,y,z}

	return pt;
end

return Torus
