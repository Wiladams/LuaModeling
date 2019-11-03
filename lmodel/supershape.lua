local polymesh = require ("lmodel.polymesh")
local sqrt = math.sqrt
local sin, cos = math.sin, math.cos
--[[
=========================================
 SuperFormula evaluation
=========================================
--]]
--local pi = 3.1415926535898
local pi = math.pi


-- Calculate length of a vector
function vlength(v)
	return sqrt(v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

-- Turn polar back to cartesian
function pocart(r0,r1, t1, p1)
	return {r0*cos(t1)*r1*cos(p1),r0*sin(t1)*r1*cos(p1),r1*sin(p1)}
end

-- Create an instance of the supershape data structure
function supershape(m,n1,n2, n3, a, b)
	return {m,n1,n2,n3,a,b}
end

function SSCos(shape, phi)
	return math.pow( math.abs(math.cos(shape[1]*phi/4) / shape[5]), shape[3])
end

function SSSin(shape, phi)
	return math.pow(math.abs(math.sin(shape[1]*phi/4) / shape[6]), shape[4])
end

function SSR(shape, phi)
	return math.pow((SSCos(shape,phi) + SSSin(shape,phi)), 1/shape[2])
end

--[[
function _EvalSuperShape2D3(phi, r)
	if math.abs(r) == 0 then
		return {0,0,0}
	else
		return {1/r * math.cos(phi), 1/r*math.sin(phi),0}
	end
end

function _EvalSuperShape2D2(phi, n1, t1, t2)
	return _EvalSuperShape2D3(phi, t1, t2, r=pow(t1+t2, 1/n1));


function EvalSuperShape2D(shape, phi) = _EvalSuperShape2D2(phi, shape[1], t1=SSCos(shape,phi), t2=SSSin(shape,phi));
--]]

--[[

	Module: RenderSuperShape()

	Description: Render a SuperFormula based shape in 3D

	Note:
	In order to truly appreciate what's going on here, and what are useful parameters to play
	with, you should consult the original Paul Bourke web page:
		http://paulbourke.net/geometry/supershape3d/
--]]

function nozeros(v1,v2,v3,v4)
	return v1 ~=0 and v2~=0 and v3~=0 and v3~=0
	--return true
end



function RenderSuperShape(shape1, shape2,	phisteps, thetasteps)

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
