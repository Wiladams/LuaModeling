require "STLWriter"


function test_writefacet()

	local facet = {
		{1,1,1},
		{2,2,2},
		{3,3,3}
	};

	writeASCIISTLFacet(facet1);
end

function test_writeASCIISTL()
	local facet = {
		{1,1,1},
		{2,2,2},
		{3,3,3}
	};

	writeASCIISTL('testname', {facet});

end

--test_writefacet();
test_writeASCIISTL();
