package.path = "../?.lua;"..package.path

local stl = require "lmodel.STLWriter"


local function test_writefacet()

	local facet = {
		{1,1,1},
		{2,2,2},
		{3,3,3}
	};

	stl.writeASCIISTLFacet(facet1);
end

local function test_writeASCIISTL()
	local facet = {
		{1,1,1},
		{2,2,2},
		{3,3,3}
	};

	stl.writeASCIISTL('testname', {facet});

end

--test_writefacet();
test_writeASCIISTL();
