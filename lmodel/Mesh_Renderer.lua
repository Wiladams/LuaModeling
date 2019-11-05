
local oscad = require("lmodel.openscad_print")
local imaging = require "lmodel.imaging"
require "lmodel.openscad_print"

local exports = {}

local function gridIterator(width, depth, resx, resy)
	
	local function gen(param, state)
		local xcnt = state.xcount
		local ycnt = state.ycount
	
		if (xcnt > param.xiter) then
			xcnt = 0;
			ycnt = ycnt+1;
			if (ycnt > param.yiter) then
				return nil;
			end
		end
	
		-- These represent the mesh coordinates
		local x1=xcnt*param.cellwidth;
		local y1=ycnt*param.cellheight;
	
		-- These represent the normalized coordinates
		local x1frac = (xcnt)/param.xiter;
		local y1frac = (ycnt)/param.yiter;
	
		xcnt = xcnt + 1
	
		return {xcount = xcnt, ycount = ycnt}, {{x1,y1},{x1frac,y1frac}}
	end

	local param = {
		xiter = width * resx;	-- how many iterations
		yiter = depth * resy;

		cellwidth = 1/resx, 	-- how big is each quad in the mesh
		cellheight=1/resy
	}
	local state = {xcount=0, ycount=0}

	return gen, param, state
end
exports.gridIterator = gridIterator



local function PrintHeightMesh(width, depth, resolution, scale, heightmap)
	local hmwidth = heightmap[1];
	local hmdepth = heightmap[2];

 	-- How many iterations
 	local xcount = (width*resolution.xres)+1;
 	local ycount = (depth*resolution.yres)+1;

	-- First get the vertices and normalized coordinates
	local polypoints = {};

	-- Use the height map to calculate the heights for each
	-- vertex, and create the points for the mesh
	for _, pt in gridIterator(width,depth, resolution.xres, resolution.yres) do
		local s = pt[2][1];
		local t = pt[2][2];
--io.write('s: ',s,' t: ',t,'\n');
		local txcoord = imaging.image_gettexelcoords({hmwidth,hmdepth},s,t)
--io.write('\ntxcoord: ',txcoord[1], ' ',txcoord[2],'\n');
		local offset = imaging.heightfield_getoffset(hmwidth,hmdepth, txcoord)
--io.write('\nOffset: ', offset,'\n');
		local height = heightmap[4][offset]
		local hscaled = height * scale;
--io.write(height);
		local point = {pt[1][1], pt[1][2], hscaled};
--print(point, point[1],point[2],point[3])
		table.insert(polypoints, point);
	end

	-- Write the polyhedron out to a file
	local f = assert(io.open("output/GetHeightMesh.scad", 'w'));

	oscad.polyhedron_print(f, polypoints, xcount, ycount);
	f:close();
end
exports.PrintHeightMesh = PrintHeightMesh

return exports
