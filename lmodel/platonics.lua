-- platonics.lua
--
-- BanateCAD
-- Copyright (c) 2019  William Adams
--
local maths = require("lmodel.maths")
local glsl = require("lmodel.glsl")
local TriangleMesh = require("lmodel.trimesh")

local sph_to_cart = spherical.sph_to_cart
local sphu_from_cart = spherical.sphu_from_cart

local Cphi = maths.Cphi


local exports = {}

local PlatonicSolid = {}
setmetatable(PlatonicSolid, {
    __call = function(self, ...)
        return self:new(...)
    end;
})
local PlatonicSolid_mt = {
    __index = PlatonicSolid;
}

function PlatonicSolid.new(self, obj)
    obj = obj or {}
    obj.radius = obj.radius or 1

    setmetatable(obj, PlatonicSolid_mt)
    obj:createMesh()

    return obj
end

function PlatonicSolid.createMesh(self)
    local mesh = TriangleMesh {}

    local verts
	if self.radius ~= nil then
		verts = self.unit_coords(self.radius)
	else
		verts = self.cart_coords
    end
    
    for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(self.faces) do
		mesh:addface(face)
	end

    self.mesh = mesh
    
    return self;
end

function PlatonicSolid.getMesh(self)
    if not self.mesh then
        self:createMesh()
    end

    return self.mesh
end
exports.PlatonicSolid = PlatonicSolid


--[[
    Tetrahedron
--]]
local tetra_cart = {
	{1, 1, 1},
	{-1, -1, 1},
	{-1, 1, -1},
	{1, -1, -1}
};


local function tetra_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(tetra_cart[1], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[2], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[3], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[4], rad)),
	};
end


local tetra_faces = {
	{1, 4, 2},
	{1,2,3},
	{3,2,4},
	{1,3,4}
};

local tetra_edges = {
	{1,2},
	{1,3},
	{1,4},
	{2,3},
	{2,4},
	{3,4},
	};

local function Tetrahedron(params)
    params = params or {}
    params.unit_coords = params.unit_coords or tetra_unit
    params.cart_coords = params.cart_coords or tetra_cart
    params.faces = params.faces or tetra_faces

    return PlatonicSolid(params)
end


exports.Tetrahedron = Tetrahedron


--[[

//	Hexahedron - Cube
//================================================
--]]
-- vertices for a unit cube with sides of length 1
local hexa_cart = {
	{0.5, 0.5, 0.5},
	{-0.5, 0.5, 0.5},
	{-0.5, -0.5, 0.5},
	{0.5, -0.5, 0.5},
	{0.5, 0.5, -0.5},
	{-0.5, 0.5, -0.5},
	{-0.5, -0.5, -0.5},
	{0.5, -0.5, -0.5},
};


local function hexa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(hexa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[6], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[7], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[8], rad)),
	};
end


-- enumerate the faces of a cube
-- vertex order is clockwise winding
local hexa_faces = {
	{1,4,3},	-- top
	{1,3,2},
	{1,2,6},
	{1,6,5},
	{2,3,7},
	{2,7,6},
	{3,4,8},
	{3,8,7},
	{4,1,5},
	{4,5,8},
	{5,6,7},	-- bottom
	{5,7,8},
};

--[[
hexa_edges = [
	[0,1],
	[0,3],
	[0,4],
	[1,2],
	[1,5],
	[2,3],
	[2,6],
	[3,7],
	[4,5],
	[4,7],
	[5,4],
	[5,6],
	[6,7],
	];
--]]

local function Hexahedron(params)
    params = params or {}
    params.unit_coords = params.unit_coords or hexa_unit
    params.cart_coords = params.cart_coords or hexa_cart
    params.faces = params.faces or hexa_faces

    return PlatonicSolid(params)
end
exports.Hexahedron = Hexahedron



--[[
//================================================
//	Octahedron
//================================================
--]]

local octa_cart = {
	{1, 0, 0},  -- + x axis
	{-1, 0, 0},	-- - x axis
	{0, 1, 0},	-- + y axis
	{0, -1, 0},	-- - y axis
	{0, 0, 1},	-- + z axis
	{0, 0, -1} 	-- - z axis
};

local function octa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(octa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[6], rad)),
	};
end

local octa_faces = {
	{5,3,1},
	{5,1,4},
	{5,4,2},
	{5,2,3},
	{6,1,3},
	{6,4,1},
	{6,2,4},
	{6,3,2}
	};
--[[
octa_edges = [
	[0,2],
	[0,3],
	[0,4],
	[0,5],
	[1,2],
	[1,3],
	[1,4],
	[1,5],
	[2,4],
	[2,5],
	[3,4],
	[3,5],
	];

function octahedron(rad=1) = [octa_unit(rad), octafaces, octa_edges];
--]]

local function Octahedron(params)
    params = params or {}
    params.unit_coords = params.unit_coords or octa_unit
    params.cart_coords = params.cart_coords or octa_cart
    params.faces = params.faces or octa_faces

    return PlatonicSolid(params)
end
exports.Octahedron = Octahedron


--[[
//================================================
//	Dodecahedron
//================================================
// (+-1, +-1, +-1)
// (0, +-1/Cphi, +-Cphi)
// (+-1/Cphi, +-Cphi, 0)
// (+-Cphi, 0, +-1/Cphi)
--]]
local dodeca_cart = {
	{1, 1, 1},			-- 0, 0
	{1, -1, 1},			-- 0, 1
	{-1, -1, 1},			-- 0, 2
	{-1, 1, 1},			-- 0, 3

	{1, 1, -1},			-- 1, 4
	{-1, 1, -1},			-- 1, 5
	{-1, -1, -1},			-- 1, 6
	{1, -1, -1},			-- 1, 7

	{0, 1/Cphi, Cphi},		-- 2, 8
	{0, -1/Cphi, Cphi},		-- 2, 9
	{0, -1/Cphi, -Cphi},		-- 2, 10
	{0, 1/Cphi, -Cphi},		-- 2, 11

	{-1/Cphi, Cphi, 0},		-- 3, 12
	{1/Cphi, Cphi, 0},		-- 3, 13
	{1/Cphi, -Cphi, 0},		-- 3, 14
	{-1/Cphi, -Cphi, 0},		-- 3, 15

	{-Cphi, 0, 1/Cphi},		-- 4, 16
	{Cphi, 0, 1/Cphi},		-- 4, 17
	{Cphi, 0, -1/Cphi},		-- 4, 18
	{-Cphi, 0, -1/Cphi},		-- 4, 19
};


local function dodeca_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(dodeca_cart[1], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[2], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[3], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[4], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[5], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[6], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[7], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[8], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[9], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[10], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[11], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[12], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[13], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[14], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[15], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[16], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[17], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[18], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[19], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[20], rad)),
	};
end


-- These are the pentagon faces
-- but CGAL has a problem rendering if things are
-- not EXACTLY coplanar
-- so use the triangle faces instead
--[[
dodeca_faces={
	{2,10,9,1,18},
	{10,2,15,16,3},
	{10,3,17,4,9},
	{9,4,13,14,1},
	{1,14,5,19,18},
	{2,18,19,8,15},
	{16,15,8,11,7},
	{3,16,7,20,17},
	{17,20,6,13,4},
	{13,6,12,5,14},
	{19,5,12,11,8},
	{20,7,11,12,6}
	};
--]]


local dodeca_faces = {
	{2,10,9},
	{2,9,1},
	{2,1,18},

	{10,2,15},
	{10,15,16},
	{10,16,3},

	{10,3,17},
	{10,17,4},
	{10,4,9},

	{9,4,13},
	{9,13,14},
	{9,14,1},

	{1,14,5},
	{1,5,19},
	{1,19,18},

	{2,18,19},
	{2,19,8},
	{2,8,15},

	{16,15,8},
	{16,8,11},
	{16,11,7},

	{3,16,7},
	{3,7,20},
	{3,20,17},

	{17,20,6},
	{17,6,13},
	{17,13,4},

	{13,6,12},
	{13,12,5},
	{13,5,14},

	{19,5,12},
	{19,12,11},
	{19,11,8},

	{20,7,11},
	{20,11,12},
	{20,12,6}
	};


--[[
dodeca_edges=[
	[0,8],
	[0,13],
	[0,17],

	[1,9],
	[1,14],
	[1,17],

	[2,9],
	[2,15],
	[2,16],

	[3,8],
	[3,12],
	[3,16],

	[4,11],
	[4,13],
	[4,18],

	[5,11],
	[5,12],
	[5,19],

	[6,10],
	[6,15],
	[6,19],

	[7,10],
	[7,14],
	[7,18],

	[8,9],
	[10,11],
	[12,13],
	[14,15],
	[16,19],
	[17,18],
	];
--]]

local function Dodecahedron(params)
    params = params or {}
    params.unit_coords = params.unit_coords or dodeca_unit
    params.cart_coords = params.cart_coords or dodeca_cart
    params.faces = params.faces or dodeca_faces

    return PlatonicSolid(params)
end
exports.Dodecahedron = Dodecahedron




--[[
//================================================
//	Icosahedron
//================================================
//
// (0, +-1, +-Cphi)
// (+-Cphi, 0, +-1)
// (+-1, +-Cphi, 0)
--]]

local icosa_cart = {
	{0, 1, Cphi},	-- 0
	{0, 1, -Cphi},	-- 1
	{0, -1, -Cphi},	-- 2
	{0, -1, Cphi},	-- 3

	{Cphi, 0, 1},	-- 4
	{Cphi, 0, -1},	-- 5
	{-Cphi, 0, -1},	-- 6
	{-Cphi, 0, 1},	-- 7

	{1, Cphi, 0},	-- 8
	{1, -Cphi, 0},	-- 9
	{-1, -Cphi, 0},	-- 10
	{-1, Cphi, 0}	-- 11
	};



local function icosa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(icosa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[6], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[7], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[8], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[9], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[10], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[11], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[12], rad)),
	};
end

local icosa_faces = {
	{4,1,5},
	{4,5,10},
	{4,10,11},
	{4,11,8},
	{4,8,1},
	{1,9,5},
	{1,8,12},
	{1,12,9},
	{5,9,6},
	{5,6,10},
	{8,11,7},
	{8,7,12},
	{10,6,3},
	{10,3,11},
	{3,7,11},
	{2,6,9},
	{2,9,12},
	{2,12,7},
	{6,2,3},
	{3,2,7}
	};

--[[
icosa_edges = [
	[0,3],
	[0,4],
	[0,7],
	[0,8],
	[0,11],
	[1,5],
	[1,8],
	[1,11],
	[1,6],
	[1,2],
	[2,5],
	[2,6],
	[2,9],
	[2,10],
	[3,4],
	[3,9],
	[3,10],
	[3,7],
	[4,5],
	[4,8],
	[4,9],
	[5,8],
	[5,9],
	[6,7],
	[6,10],
	[6,11],
	[7,10],
	[7,11],
	[8,11],
	[9,10],
	];
--]]

local function Icosahedron(params)
    params = params or {}
    params.unit_coords = params.unit_coords or icosa_unit
    params.cart_coords = params.cart_coords or icosa_cart
    params.faces = params.faces or icosa_faces

    return PlatonicSolid(params)
end
exports.Icosahedron = Icosahedron

return exports