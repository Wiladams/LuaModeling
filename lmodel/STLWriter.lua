local write = io.write
local format = string.format

local exports = {}

local function writeASCIISTLVertex(v)
	write(string.format("vertex %5.4f %5.4f %5.4f\n", v[1],v[2],v[3]));
end
exports.writeASCIISTLVertex = writeASCIISTLVertex

local function writeASCIISTLFacet(facet)
	-- calculate the facet normal
	local fnormal = {0,0,0};

	-- header
	write('facet normal 0 0 0\n');
	write('outer loop\n');

	-- print vertices
	writeASCIISTLVertex(facet[1]);
	writeASCIISTLVertex(facet[2]);
	writeASCIISTLVertex(facet[3]);

	-- footer
	write('endloop\n');
	write('endfacet\n');
end
exports.writeASCIISTLFacet = writeASCIISTLFacet

local function writeASCIISTL(name, facets)
	write(string.format('solid %s\n',name));

	for i=1,#facets  do
		writeASCIISTLFacet(facets[i]);
	end

	write(string.format("endsolid %s\n", name));
end
exports.writeASCIISTL = writeASCIISTL

return exports

