--[[
//==========================================
//	Geodesic calculations
//
//  Reference: Geodesic Math and How to Use It
//  By: Hugh Kenner
//  Second Paperback Edition (2003), p.74-75
//  http://www.amazon.com/Geodesic-Math-How-Hugh-Kenner/dp/0520239318
//
//  The book was used for reference, so if you want to check the math,
//  you can plug in various numbers to various routines and see if you get
//  the same numbers in the book.
//
//  In general, there are enough routines here to implement the various
//  pieces necessary to make geodesic objects.

BUGBUG - This is still old openscad code
needs to be converted
//==========================================
--]]

local function poly_sum_interior_angles(sides)
	return (sides-2)*180;
end 

local function poly_single_interior_angle(pq)
	return poly_sum_interior_angles(pq[0])/pq[0];
end



-- Given a set of coordinates, return the frequency
-- Simply calculated by adding up the values of the coordinates
function geo_freq(xyz) = xyz[0]+xyz[1]+xyz[2];

-- Convert between the 2D coordinates of vertices on the face triangle
-- to the 3D vertices needed to calculate spherical coordinates
function geo_tri2_tri3(xyf) = [xyf[1], xyf[0]-xyf[1], xyf[2]-xyf[0]];

-- Given coordinates for a vertex on the octahedron face
-- return the spherical coordinates for the vertex
-- class 1, method 1
function octa_class1(c) = sph(
	atan(safediv(c[0], c[1])),
	atan(sqrt(c[0]*c[0]+c[1]*c[1])/c[2]),
	1
	);

function octa_class2(c) = sph(
	atan(c[0]/c[1]),
	atan( sqrt( 2*(c[0]*c[0]+c[1]*c[1])) /c[2]),
	1
	);

function icosa_class1(c) = octa_class1(
	[
		c[0]*sin(72),
		c[1]+c[0]*cos(72),
		geo_freq(c)/2+c[2]/Cphi
	]);

function icosa_class2(c) = sph(
	atan([c0]/c[1]),
	atan(sqrt(c[0]*c[0]+c[1]*c[1]))/cos(36)*c[2],
	1
	);

function tetra_class1(c) = octa_class1(
	[
		sqrt(3*c[0]),
		2*c[1]-c[0],
		(3*c[2]-c[0]-c[1])/sqrt(2)
	]);

function class1_icosa_chord_factor(v1, v2, freq) = sph_dist(
		icosa_class1(geo_tri2_tri3( [v1[0], v1[1], freq])),
		icosa_class1(geo_tri2_tri3( [v2[0], v2[1], freq]))
	);


	return exports