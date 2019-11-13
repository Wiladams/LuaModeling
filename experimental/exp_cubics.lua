
local function GetBiCubicVertices(M, umult, cps, steps)

	G = cubic_vec3_to_cubic_vec4(cps);
	mat4_print(G);
	-- create a table for the results
	results = {};

	for step=0, steps  do
		local U = maths.cubic_U(step/steps)
		local pt0 = maths.cerp(U, M, G)

		table.insert(results, pt0);
		--vec4_print(pt0);
	end

	return results;
end
