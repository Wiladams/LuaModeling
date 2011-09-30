require "imaging"
require "openscad_print"

-- An iterator version
function Iterate2DGrid(width, depth, resx, resy)
	-- How big is each quad in the mesh
	local cellwidth = 1/resx;
	local cellheight = 1/resy;

	-- How many iterations
	local xiter = width*resx;
	local yiter = depth*resy;

	local ycnt =0;
	local xcnt =-1;

	return function()
		xcnt = xcnt+1;

		if (xcnt > xiter) then
			xcnt = 0;
			ycnt = ycnt+1;
			if (ycnt > yiter) then
				return nil;
			end
		end

		-- These represent the mesh coordinates
		x1=xcnt*cellwidth;
		y1=ycnt*cellheight;

		-- These represent the normalized coordinates
		x1frac = (xcnt)/xiter;
		y1frac = (ycnt)/yiter;


		return {{x1,y1},{x1frac,y1frac}}
	end
end





function PrintHeightMesh(width, depth, resolution, scale, heightmap)
	hmwidth = heightmap[1];
	hmdepth = heightmap[2];

 	-- How many iterations
 	local xcount = (width*resolution[1])+1;
 	local ycount = (depth*resolution[2])+1;

	-- First get the vertices and normalized coordinates
	local polypoints = {};

	-- Use the height map to calculate the heights for each
	-- vertex, and create the points for the mesh
	for pt in Iterate2DGrid(width,depth, resolution[1], resolution[2]) do
		local s = pt[2][1];
		local t = pt[2][2];
--io.write('s: ',s,' t: ',t,'\n');
		local txcoord = image_gettexelcoords({hmwidth,hmdepth},s,t)
--io.write('\ntxcoord: ',txcoord[1], ' ',txcoord[2],'\n');
		local offset = heightfield_getoffset(hmwidth,hmdepth, txcoord)
--io.write('\nOffset: ', offset,'\n');
		local height = heightmap[4][offset]
		hscaled = height * scale;
--io.write(height);
		point = {pt[1][1], pt[1][2], hscaled};
		table.insert(polypoints, point);
	end

	-- Write the polyhedron out to a file
	local f = assert(io.open("GetHeightMesh.scad", 'w'));

	polyhedron_print(f, polypoints, xcount, ycount);
	f:close();
end

