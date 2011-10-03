function writeASCIISTL(name, facets)
	io.write(string.format('solid %s\n',name));

	for i=1,#facets  do
		writeASCIISTLFacet(facets[i]);
	end

	io.write(string.format("endsolid %s\n", name));
end

function writeASCIISTLFacet(facet)
	-- calculate the facet normal
	local fnormal = {0,0,0};

	-- header
	io.write('facet normal 0 0 0\n');
	io.write('outer loop\n');

	-- print vertices
	writeASCIISTLVertex(facet[1]);
	writeASCIISTLVertex(facet[2]);
	writeASCIISTLVertex(facet[3]);

	-- footer
	io.write('endloop\n');
	io.write('endfacet\n');
end

function writeASCIISTLVertex(v)
	io.write(string.format("vertex %5.4f %5.4f %5.4f\n", v[1],v[2],v[3]));
end
