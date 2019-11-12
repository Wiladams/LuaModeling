# lmodel

![mascot](images/mascot.PNG?raw=true)

What?
=====

With LuaModeling, you can create 3D geometries and output them to OpenSCAD .scad files, or .stl

While OpenSCAD is great for generating 3D models using code, the language itself is fairly constrained, and the runtime can be slow during various operations.

LuaModeling can generate .scad and .stl files as output, so you can use OpenSCAD as a simple visualizer (which is does fairly well), and as an output converter.  Essentially, OpenSCAD is just another tool in a 3D modeling workflow.  The advantage of using lua as the modeling language is that it is very robust and fast.  When using LuaJIT as the runtime, the code becomes even faster.

You are free to use any editor you like, such as VS Code, or Sublime Text.

How
===
Installation
------------
To install, simply copy the entirety of the lmodel directory into wherever your lua is installed.

Workflow
--------
Starting from the end result, you need to decide whether you want to create a .stl, or a .scad file as your final output.  Assuming you want to generate .scad, and you want to use VS Code as your editor, you need to create your model file, which is nothing more than a '.lua' program.


```lua
local oscad = require "lmodel.openscad_print"
local f = assert(io.open("output/ex_cone.scad", 'w'));
```

Next, you load the modules that you'll be using to put your model together.  In this case, we can create a simple cone.

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
f:close()
```


Now that you've got your .lua file, you simply execute it from the command line:

```
c:> luajit ex_cone.lua
```

You will get a ex_cone.scad file in the same directory.  From there, you can open the file using the OpenSCAD program, and your mesh should show up in the window.<br/>

![cone](images/cone.PNG?raw=true)<br/>

Once you open the file in OpenSCAD, you can simply leave OpenSCAD open to make iterative changes to the source .lua program.  Since OpenSCAD can automatically watch for changes in a file, and re-render if it sees any, each time you execute the model's program, it will regenerate the .scad file, and OpenSCAD will re-render. This makes for a fairly rapid turnaround because you're not relying on OpenSCAD to generate the actual mesh, which can be fairly slow, depending on your algorithms.  You're just relying on it to render the mesh, which it can do fairly quickly.



More Examples
=============
You can look at these various [examples](https://github.com/Wiladams/LuaModeling/tree/master/examples) for ideas of what LuaModeling is capable of.


Documentation
=============
The [Documentation](docs) should give you an idea of how LuaModeling is designed, and what can be done with it.

TODO
====
* Remove more from global namespace
* Write more test cases
* Fix bugs
* Change objects to use named field instead of positions
* Add more parametric shapes
* add CSG operations
