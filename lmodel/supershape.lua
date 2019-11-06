--[[

	Module: RenderSuperShape()

	Description: Render a SuperFormula based shape in 3D

	Note:
	In order to truly appreciate what's going on here, and what are useful parameters to play
	with, you should consult the original Paul Bourke web page:
		http://paulbourke.net/geometry/supershape3d/
--]]


local PolyMesh = require ("lmodel.trimesh")
local sqrt, pow, abs = math.sqrt, math.pow, math.abs
local sin, cos = math.sin, math.cos

local exports = {}

--[[
=========================================
 SuperFormula evaluation
=========================================
--]]
--local pi = 3.1415926535898
local pi = math.pi


-- Calculate length of a vector
local function vlength(v)
	return sqrt(v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

-- Turn polar back to cartesian
local function pocart(r0,r1, t1, p1)
	return {r0*cos(t1)*r1*cos(p1),r0*sin(t1)*r1*cos(p1),r1*sin(p1)}
end

local function SSCos(shape, phi)
	return pow( abs(cos(shape.m*phi/4) / shape.a), shape.n2)
end

local function SSSin(shape, phi)
	return pow(abs(sin(shape.m*phi/4) / shape.b), shape.n3)
end

local function SSR(shape, phi)
	return pow((SSCos(shape,phi) + SSSin(shape,phi)), 1/shape.n1)
end





local function nozeros(v1,v2,v3,v4)
	return v1 ~=0 and v2~=0 and v3~=0 and v3~=0
end



local function getMesh(shape1, shape2,	phisteps, thetasteps)

	local mesh = PolyMesh:new()

	for i = 0, thetasteps-1 do 		-- theta (longitude) -pi to pi

		for j = 0, phisteps-1 do	-- phi (latitude) -pi/2 to pi/2

			local theta1 = -pi + i * 2*pi / thetasteps
			local theta2 = -pi + (i+1)*2*pi / thetasteps

			local phi1 = -pi/2 + j*1*pi/phisteps
			local phi2 = -pi/2 + (j+1)*1*pi/phisteps
--print(theta1, theta2)
			-- Calculate 4 radii
			local r0 = SSR(shape1, theta1)
			local r1 = SSR(shape2, phi1)
			local r2 = SSR(shape1, theta2)
			local r3 = SSR(shape2, phi2)

			if nozeros(r0,r1,r2,r3) then

				local pa = mesh:addvertex(pocart(1/r0,1/r1,theta1,phi1))
				local pb = mesh:addvertex(pocart(1/r2, 1/r1, theta2, phi1))
				local pc = mesh:addvertex(pocart(1/r2, 1/r3, theta2, phi2))
				local pd = mesh:addvertex(pocart(1/r0, 1/r3, theta1, phi2))

				mesh:addface({pa, pd, pc})
				mesh:addface({pa, pc, pb})
			end
		end
	end

	return mesh
end
exports.getMesh = getMesh

-- Create an instance of the supershape data structure
-- simple helper to turn parameter list into 
-- table of named parameters
function supershape(m,n1,n2, n3, a, b)
	return {m=m,n1=n1,n2=n2,n3=n3,a=a,b=b}
end
exports.supershape = supershape

return exports

