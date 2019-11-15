# Documentation

Conceptual Design
-----------------
The core design concept of LuaModeling is that the lua language itself is used as the design language.  As lua is a general purpose language, with a fully mature syntax, and a JIT compiler runtime, model building can be efficient and fast.  The lua syntax for table building, compound object construction, loops and control constructs, even iterators and co-routines, can all be applied to the task of building 3D models.  After a model is created, any number of external representations can be used.  

The first form of external representation is the '.scad' file.  OpenSCAD itself is a meaningful 3D CAD modeling software, but for the purposes of LuaModeling, it is nothing more than a common output format.  LuaModeling does not rely on any aspect of the OpenSCAD program itself, but you can use OpenSCAD as a convenient model viewer in your workflow.  LuaModeling can output a '.scad' file, but does not take advantage of any other aspects of the OpenSCAD environment.  From within the OpenSCAD environment, you can generate .stl and other output formats if you like.

At present, LuaModeling lacks any form of complex scene creation.  It is best for generating single objects which can then be combined with other objects using other tools.  The real benefit at the moment, is creating those complex algorithmically generated objects that are very hard to do using other means.  Future modules will include the ability to perform CSG operations, but it will be built upon the same fundamental mesh objects that currently exist in the library.

A key design principle is the lack of any external dependencies.  LuaModeling limits itself to whatever can be done within the packaged files themselves, not relying on any external libraries, OS features, or companion programs.  This makes it extremely portable to any environment that has nothing more than a lua interpreter.

LuaModeling follows a principle of composite design.  That simply means where it makes sense, 'inheritance' is employed, and in other cases, parameters are passed along.  This makes for a fairly robust yet streamlined interface.  This can be seen most dramatically in the BiParametric object.  From this base, just about any 3D surface based thing can be created.  This is used to support the torus, to ellipsoid, and metaball objects.

Similarly, the supershape is a highly parameterized structure, which can be used to create anyting from a rounded cube to a snail's shell.

Since the build/model/view pipeline is relatively simple, the workflow encourages rapid experimentation.  Iteration is your friend.


Building Blocks
---------------
* [trimesh](trimesh.md)
* [openscad_print](openscad.md)
* STLWriter - a work in progress
* MeshRenderer - a work in progress
* [glsl](glsl.md)
* imaging - a work in progress
* [maths](maths.md)

Shapes
------
* cone
* BiParametric
    * metaball
    * ellipsoid
    * toroid
* supershape