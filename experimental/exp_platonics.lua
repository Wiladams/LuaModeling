--[[

// Information about platonic solids
// This information is useful in constructing the various solids
// can be found here: http://en.wikipedia.org/wiki/Platonic_solid
// V - vertices
// E - edges
// F - faces
// number, V, E, F, schlafli symbol, dihedral angle, element, name
//tetrahedron = [1, 4, 6, 4, [3,3], 70.5333, "fire", "tetrahedron"];
//hexahedron = [2, 8, 12, 6, [4,3], 90, "earth", "cube"];
//octahedron = [3, 6, 12, 8, [3,4], 109.467, "air", "air"];
//dodecahedron = [4, 20, 30, 12, [5,3], 116.565, "ether", "universe"];
//icosahedron = [5, 12, 30, 20, [3,5], 138.190, "water", "water"];
--]]


-- Schlafli representation for the platonic solids
-- Given this representation, we have enough information
-- to derive a number of other attributes of the solids
class.schlafli()
function schlafli:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.p = params.p
	self.q = params.q
end

tetra_sch = schlafli({p=3,q=3});
hexa_sch = schlafli({p=4,q=3});
octa_sch = schlafli({p=3,q=4});
dodeca_sch = schlafli({p=5,q=3});
icosa_sch = schlafli({p=3,q=5});

--[[
-- Given the schlafli representation, calculate
-- the number of edges, vertices, and faces for the solid
function plat_edges(pq)
	return (2*pq[1]*pq[2])/
	((2*pq[1])-(pq[1]*pq[2])+(2*pq[2]));
end

function plat_vertices(pq)
	return (2*plat_edges(pq))/pq[2];
end

function plat_faces(pq)
	return (2*plat_edges(pq))/pq[1];
end



-- Calculate angular deficiency of each vertex in a platonic solid
-- p - sides
-- q - number of edges per vertex
--function angular_defect(pq) = math.pi*2 - (poly_single_interior_angle(pq)*pq[2]);
function plat_deficiency(pq)
	return math.deg(2*Cpi - pq[2]*Cpi*(1-2/pq[1]));
end

function plat_dihedral(pq)
	return 2 * math.asin( math.cos(math.pi/pq[2])/math.sin(math.pi/pq[1]));
end

function plat_circumradius(pq, a)
	return (a/2)*
	math.tan(Cpi/pq[2])*
	math.tan(plat_dihedral(pq)/2);
end

function plat_midradius(pq, a)
	return (a/2)*
	math.cot(Cpi/pq[1])*
	math.tan(plat_dihedral(pq)/2);
end

function plat_inradius(pq,a)
	return a/(2*math.tan(Cpi/pq[1]))*
	math.sqrt((1-math.cos(plat_dihedral(pq)))/(1+math.cos(plat_dihedral(pq))));
end
--]]

--[[
shape_platonic = {}
function shape_platonic:_init(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_tetrahedron.GetMesh(self)
	local mesh = trimesh({name="tetrahedron"})

	for i,v in ipairs(tetra_cart) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(tetra_faces) do
		mesh:addface(face)
	end

	return mesh;
end
--]]