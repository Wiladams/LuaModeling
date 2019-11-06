LuaModeling is a library of 3D modeling routines written using
the Lua language.

![supershape](images/supershape2.PNG?raw=true)

There are a number of techniques I want to use in 3D modeling.  My primary tool 
of choice is OpenSCAD.  I choose OpenSCAD because it's relatively easy to use from
a programmer's perspective.  It does not have a very robust graphical interface
for interacting with your models, rather it relies on code to do the modeling.

I find OpenSCAD to be a bit limiting in the language itself, but it has a 
polygon mesh object that it can render, so the approach taken in LuaModeling 
is to use Lua as the modeling engine, and just output polygon mesh objects to 
be rendered by OpenSCAD.

A good workflow is to create your models in LuaModeling, which will then 
generate an OpenSCAD file.  Then, open this file using OpenSCAD, and keep 
it open.  If you make changes to your original file, and generate the .scad 
file again, it will be automatically rendered, because OpenSCAD tracks changes
to source files, and automatically re-renders.

By doing things this way, you're free to experiment with modeling techniques
using Lua as your language, which is much faster and more flexible than OpenSCAD.

Usage
=====
Look at the various test cases for examples of what can be done.

As well as generating polygon mesh objects for OpenSCAD, you can generate a .stl file
directly from the mesh as well.  That makes it perfect for generating files for 
3D printing directly.

Examples
========
testy/test_mesh_lofting.lua  An example of attaching a height map to a mesh

![supershape](images/heightmap.PNG?raw=true)

testy/test_cone.lua  An example of a simple cone
![supershape](images/cone.PNG?raw=true)

TODO
====
* Remove more from global namespace
* Write more test cases
* Fix any bugs
* Change objects to use named field instead of positions
