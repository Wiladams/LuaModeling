# lmodel

![mascot](images/mascot.PNG?raw=true)

What?
=====

With LuaModeling, you can create 3D geometries and output them to OpenSCAD .scad files, or .stl

I like OpenSCAD for its simplicity.  You can create fairly complex 3D models by writing
code.  The OpenSCAD UI contains an editor and viewer, but the language itself is fairly constrained.

LuaModeling recognizes that .scad and .stl files are fairly common, so it uses those
formats as output.  The advantage of LuaModeling is using a very robust and fast language
for creating the code for the 3D models.  Atop this, if you use LuaJIT, the code becomes even
faster.

What this essentially does is use Lua as the modeling language, and .scad and .stl as the 
universal output format.  You are free to use any editor you like, such as VS Code, or Sublime Text.

How
===
Installation
------------
To install, simply copy the entirety of the lmodel directory into wherever your lua is
installed.

Workflow
--------
Starting from the end result, you need to decide whether you want to create a .stl, or a .scad file as your final output.  Assuming you want to generate .scad, and you want to use VS Code as your editor, you need to create your model file, which is nothing more than a '.lua' program.


```lua
local oscad = require "lmodel.openscad_print"
local f = assert(io.open("output/cone.scad", 'w'));
```

Next, you load the modules that you'll be using to put your model together.  In this case, we
can create a simple cone.

```lua
local cone = require("lmodel.cone")
local c1 = cone {
    anglesteps = 30;
    baseradius = 50;
    topradius = 0;
    height=100
}
```


Finally, you will want to generate the mesh, and write it to the output file.  In the case of OpenSCAD output, a triangle mesh is typically what you will output.  You can also output a flat 2D polygon if that's right for your geometry, but most of the time you're going to generate a full polyhedron.

```lua
oscad.PolyMesh_print(f,c1:getMesh())
```


Now that you've got your .lua file, you simply execute it from the command line:

```
c:> luajit cone.lua
```

You will get a cone.scad file in the same directory.  From there, you can open the file using
the OpenSCAD program, and your mesh should show up in the window.<br/>

![cone](images/cone.PNG?raw=true)<br/>

Once you open the file in OpenSCAD, you can simply leave OpenSCAD open to make iterative changes to the source .lua program.  Each time you execute the model's program, it will regenerate the .scad file, which will cause OpenSCAD to read it again and re-render your model. This makes for a fairly rapid turnaround because you're not relying on OpenSCAD to generate the actual mesh, which can be fairly slow.  You're just relying on it to render the mesh, which it can do fairly quickly.




More Examples
=============
There are a growing number of [examples](https://github.com/Wiladams/LuaModeling/tree/master/examples) you can explore.  Here are a few simple ones to get a feel for the kinds of things
you can create.




TODO
====
* Remove more from global namespace
* Write more test cases
* Fix bugs
* Change objects to use named field instead of positions
* Add more parametric shapes
* add CSG operations
