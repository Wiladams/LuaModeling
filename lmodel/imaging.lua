--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--=====================================

require "lmodel.glsl"



--	Function: map_to_array
--
--	Description
--		This routine will return which element in the array corresponds
--		to the normalized value 'u' specified.
--
--	Parameters
--		len - length of array
--		u - normalized value from 0..1


function map_to_array(range, u)
	local val = clamp(ceil(range*u),1,range);

	return val;
end

--	Function: image()
--
--	Description: Create an image object for later usage.  The image
--	Is a RGB, interleaved image, with all elements flat in the array
--
--	Parameters:
--		width  - width in pixels
--		height - height in pixels
--		maxvalue	- The maximum value of any component
--		values - The array of values representing the image

function image(width, height, maxvalue, values, cpe)
	return {width, height, maxvalue, values, cpe};
end

function image_pixel_normalize(img, pixel)
	return {pixel[1]/img[3], pixel[2]/img[3], pixel[3]/img[3]};
end

function image_getoffset(size, xy, cpe)
	return ((size[1]*(size[2]-1-xy[2]))+xy[1])*cpe;
end

function _image_getpixel_1(img, offset)
	return {img[4][offset],img[4][offset],img[4][offset]};
end

function _image_getpixel_2(img, offset)
	return {img[4][offset],img[4][offset+1]};
end

function _image_getpixel_3(img, offset)
	return {img[4][offset],img[4][offset+1],img[4][offset+2]};
end

function _image_getpixel_4(img, offset)
	return {img[4][offset],img[4][offset+1],img[4][offset+2],img[4][offset+3]};
end

function _image_getpixel(img, offset)
	if (img[5] == 1) then
		return _image_getpixel_1(img,offset)
	end

	if	(img[5] == 3) then
		return _image_getpixel_3(img,offset)
	end

	if (img[5] == 4) then
		return _image_getpixel_4(img,offset)
	end

	if (img[5] == 2) then
		return _image_getpixel_2(img,offset)
	end

	return {0};
end

function image_getpixel(img, xy)
	return _image_getpixel(img, image_getoffset({img[1],img[2]}, xy));
end

function image_gettexelcoords(size, s, t)
	txcoord = {map_to_array(size[1],s), map_to_array(size[2],t)};
	return txcoord;
end


function heightfield_getoffset(width, depth, xy)
	local offset = (width*(depth-xy[2]))+xy[1];
	return offset;
end

function heightfield_getvalue(img, s, t)
	return img[4][heightfield_getoffset(img[1],img[2], image_gettexelcoords({img[1],img[2]},s,t))];
end

function image_gettexel(img, s, t)
	return image_pixel_normalize(img, image_getpixel(img, image_gettexelcoords(img,s,t)));
end


--	checker_image
--
--	This is a useful image to be used if no other image is available.
--	It is a simple black/white image that is 8x8 pixels, like a standard
--	chess board.

checker_array = {
0, 1, 0, 1, 0, 1, 0, 1,
1, 0, 1, 0, 1, 0, 1, 0,
0, 1, 0, 1, 0, 1, 0, 1,
1, 0, 1, 0, 1, 0, 1, 0,
0, 1, 0, 1, 0, 1, 0, 1,
1, 0, 1, 0, 1, 0, 1, 0,
0, 1, 0, 1, 0, 1, 0, 1,
1, 0, 1, 0, 1, 0, 1, 0,
};

checker_image = image(8,8,1, checker_array, 1);

--====================================
-- COLOR MAPPING
--====================================

-- For modern day monitor luminance
function luminance(rgb)
	return dot({0.2125, 0.7154, 0.0721}, rgb);
end

-- For non-linear luminance, and old NTSC
function luminance_ntsc(rgb)
	return dot({0.299, 0.587, 0.114}, rgb);
end
