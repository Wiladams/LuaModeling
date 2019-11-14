--[[
	OpenSCAD print routines
	Turn various parts of geometry into their OpenSCAD
	equivalents.

	PolyMesh_print() is the primary function to use from this file
]]

local exports = {}
local write = io.write
local format = string.format

-- Convenient print routines
local function fwrite(f, ...)
	f:write(...)
end

local function fprintf(f, fmt, ...)
	f:write(format(fmt, ...))
end

local function printf(fmt, ...)
	fprintf(io.stdout, fmt, ...)
end


--[[ 
	Writing various vector types
--]]
local function vec_fwrite(f, v)
	f:write("[");
	for i=1, #v do
		f:write(v[i]-1,',');
	end
	f:write(']');
end



local function vec2_fwrite(f, v)
	return fwrite(f, '[', v[1],',',v[2],']');
end

local function vec2_write(v)
	return vec2_fwrite(io.stdout, v)
end

local function vec3_fwrite(f, v)
	f:write(format("[%5.4f,%5.4f,%5.4f]", v[1],v[2],v[3]));
end

local function vec3_write(v)
	vec3_fwrite(io.stdout, v)
end
exports.vec3_write = vec3_write

local function vec3_print_tuple(v)
	io.write(v[1],',',v[2],',',v[3],'\n');
end

local function matx3_print(a)
	print("[");
	for i=1,#a  do
		vec3_print(a[i]);
		io.write(",\n");
	end
	print("]");
end


local function vec4_print(v)
	write('[', v[1],',',v[2],',',v[3],',',v[4],']');
	--io.write("[%5.2f,%5.2f,%5.2f,%5.2f]", v[1],v[2],v[3],v[4]);
end

local function vec4_fprint(f, v)
	fwrite(f,'[', v[1],',',v[2],',',v[3],',',v[4],']');
	--io.write("[%5.2f,%5.2f,%5.2f,%5.2f]", v[1],v[2],v[3],v[4]);
end

local function mat4_print(m)
	print('[');
	vec4_print(m[1]);io.write('\n');
	vec4_print(m[2]);io.write('\n');
	vec4_print(m[3]);io.write('\n');
	vec4_print(m[4]);io.write('\n');
	print(']');
end
exports.mat4_print = mat4_print




local function matx4_print(a)
print("[");
	for i=1,#a  do
		vec4_print(a[i]);
		io.write(",\n");
	end
	print("]");
end
exports.mat4_print = matx4_print

local function table_fprint_indices(f, a)
	fwrite(f, "[\n");
	for i=1, #a do
		f:write(i-1,',');
	end
	f:write(#a);
	f:write("]\n");
end

local function table_print_indices(a)
    return table_fprint_indices(io.stdout, a)
end

local function polygon_fprint(f, a)
	fprintf(f, "polygon(points=\n");
	fprintf(f, "[");
	for i=1,#a  do
		vec2_fwrite(f, a[i]);
		fwrite(f, ",\n");
	end
	fprintf(f, "],\n");
	fprintf(f, "paths=[\n");
	table_fprint_indices(f, a);
	fprintf(f, "]);\n");
end
exports.polygon_fprint = polygon_fprint

local function polygon_print(a)
	return polygon_fprint(io.stdout, a)
end
exports.polygon_print = polygon_print

local function imesh(col, row, width)
	index = ((row-1)*width)+col-1;
	return index;
end

local function quad_indices_from_polymesh(width, height)
	local indices = {};

	for row =1, height-1 do
		local quadstrip = {};
		for col =1, width-1 do
			local quad = {imesh(col, row, width),imesh(col+1, row, width),
							imesh(col+1, row+1, width), imesh(col, row+1, width)};
			table.insert(indices, quad);
		end
	end

	return indices;
end

local function polyhedron_fprint(f, pts, width, height)

	f:write("polyhedron(points=\n");
	f:write("[\n");
	for i,pt in ipairs(pts) do
		vec3_fwrite(f, pt);
		f:write(",\n");
	end
	f:write("],\n");

	local indices = quad_indices_from_polymesh(width, height);

	f:write("faces=[\n");
	for i,v in ipairs(indices) do
		vec4_fprint(f,v); f:write(',\n');
	end
	f:write("]);\n");
end
exports.polyhedron_fprint = polyhedron_fprint

local function polyhedron_print(pts, width, height)
	return polyhedron_fprint(io.stdout, pts, width, height)
end
exports.polyhedron_print = polyhedron_print


local function PolyMesh_fprint(f, mesh, tformer)
	f:write("polyhedron(\n")
	f:write("points = [\n");
	for i,pt in ipairs(mesh:Vertices()) do
		if tformer then
			pt = tformer:transformPoint(pt)
		end
		vec3_fwrite(f, pt);
		f:write(",\n");
	end
	f:write("],\n");

	f:write("faces = [\n");
	for i,v in ipairs(mesh:Faces()) do
		vec_fwrite(f, v)
		f:write(',\n')
	end
	f:write("]);\n");
end
exports.PolyMesh_fprint = PolyMesh_fprint

--[[
local function PolyMesh_print(mesh, tformer)
	PolyMesh_printf(io.stdout, mesh, tformer)
end
--]]

exports.PolyMesh_print = PolyMesh_fprint

return exports