-- shape_ellipsoid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
local glsl = require("lmodel.glsl")
local cos, sin = math.cos, math.sin

local BiParametric = require "lmodel.biparametric"


local Ellipsoid = {}
setmetatable(Ellipsoid, {
    __index = BiParametric;
    __call = function(self, ...)
        return self:new(...)
    end;
})
local Ellipsoid_mt = {
    __index = Ellipsoid;
}


function Ellipsoid.new(self, obj)
    obj = BiParametric:new(obj)

	-- Get our specifics out of the parameters
	obj.XRadius = obj.XRadius or 1
	obj.ZRadius = obj.ZRadius or 1
	obj.MaxTheta = obj.MaxTheta or 2*math.pi
	obj.MaxPhi = obj.MaxPhi or math.pi

    setmetatable(obj, Ellipsoid_mt)

    return obj
end

function Ellipsoid.getProfileVertex(self, u)
	local angle = u*self.MaxTheta
	local x = self.XRadius*math.sin(angle)
	local y = self.XRadius*math.sin(angle)
	local z = self.ZRadius*math.cos(angle)

	return {x,y,z}
end

-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function Ellipsoid.getVertex(self, u, w)
	theta = u * self.MaxTheta
	phi = math.pi - w * self.MaxPhi

	local xr = self.XRadius*sin(phi)*cos(theta)
	local yr = self.XRadius*sin(phi)*sin(theta)
	local zr = self.ZRadius*cos(phi)

	local vert =  {xr, yr, zr}

	local normal = glsl.normalize(vert)

	return vert, normal
end

function Ellipsoid.__tostring(self)
	return "Ellipsoid({XRadius = "..self.XRadius..", ZRadius ="..self.ZRadius..'})'
end

return Ellipsoid