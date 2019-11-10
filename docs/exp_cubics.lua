local function cubic_surface_pt(T, A, G, S)
	local pt = vec3_from_point3h(
		vec4_mult_mat4(vec4_mult_mat4(vec4_mult_mat4(T,A), G),S)
	);
	return pt;
end
