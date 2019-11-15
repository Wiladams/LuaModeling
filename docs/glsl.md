# glsl

The natively supported math library in lua has various trigonometry and other functions.  When doing 3D modeling, there is a need for these trig functions, and quite a few more.  In addition to the basic trig, you want to perform functions on arrays of values, not just single values.  There is also need for clamping, linear interpolation, curve evaluation, and a few more.

LuaModeling provides a set of math functions that augment and enhance the basic lua math library.  As a convenience, LuaModeling supports an interface that is familiar to the OpenGL Shading Language (glsl).  The functions are listed below.  More complete documentation on how they behave can be found by searching for 'glsl core functions'.

Arithmetic
----------
* add
* sub
* mul
* div
* equal
* notEqual

Trigonometry
------------
* radians
* degrees
* sin
* cos
* tan
* asin
* acos
* atan
* atan2
* sinh
* cosh
* tanh

Exponential Functions
---------------------
* pow
* exp2
* log2
* sqrt
* inv
* invsqrt

Common Functions
----------------
* abs
* sign
* floor
* trunc
* round
* ceil
* fract
* max
* min
* mix
* mod
* clamp

Curves
------
* step
* herm
* smoothstep

Geometric Functions
-------------------
* dot
* length
* normalize
* distance
* cross

Vector Related
--------------
* isnumtrue
* any
* all
