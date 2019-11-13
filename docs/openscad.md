mat4_print
polygon_print
PolyMesh_print

The primiary function of the [openscad_print] module is to convert from the internal triangle mesh representation of a geometry into the OpenSCAD polyhedron form.  The single routine that does this is "PolyMesh_print(mesh, transform)".

PolyMesh_print, takes two parameters.  The first is the mesh to be converted.  This mesh can be created by any means necessary, and the rest of the LuaModeling library provides several routines for creating these meshes using various techniques.  However it's done, this mesh parameter is required.

The transform, is a 4x4 matrix transform that can be applied to the vertices as the mesh is being printed.  This does not alter the vertices in the mesh itself, but generates converted vertices.

Here is a very simple case.  A mesh is created, and output to a OpenSCAD file, without applying any particular transform (default is identity matrix).

```lua
local TriangleMesh = require("lmodel.trimesh")
local mesh = TriangleMesh:new({
    vertices = {
        {0,0,0},
        {10,0,0},
        {10,10,0},
        {0, 10, 0}
    };
    faces = {
        {1,2,3},
        {1,3,4}
    }
})

local oscad = require "lmodel.openscad_print"
local f = assert(io.open("ex_trimesh.scad", 'w'));
oscad.PolyMesh_print(f,mesh)
f:close()
```

The output is the following OpenSCAD output.

```OpenSCAD
polyhedron(points= [
[0.0000,0.0000,0.0000],
[10.0000,0.0000,0.0000],
[10.0000,10.0000,0.0000],
[0.0000,10.0000,0.0000],
],
faces=[
[0,1,2,],
[0,2,3,],
]);
```

It is a fairly straight forward conversion from the internal representation of the triangle mesh and the OpenSCAD form.  The 'vertices' become 'points', and the 'faces' remain 'faces'.

Upon rendering you should see the following.

![trimesh](images/trimesh1.PNG?raw=true)

Transformations
---------------

You can use the transformation parameter to adjust the scale, rotation, and location of the mesh as you output it to OpenSCAD.  The details of the transform are documented separately, but it is a simply straightforward procedure.  If we want to do a translation, and a scale, we could do the following.

```lua
local Transformer = require("lmodel.Transformer")
local tform1 = Transformer()
tform1:translate(5,5, 3)
tform1:scale(2,2,1)
oscad.PolyMesh_print(f,mesh, tform1)
```

![trimesh2](images/trimesh2.PNG?raw=true)

That is pretty much all there is to generating OpenSCAD output.  There is room for specialization of various forms of other routines, but that would be up to the user to create the output.  For example, rather than converting a sphere to a mesh, and outputting the mesh, you could simply output the geometry of the sphere in standard OpenSCAD form for spheres.  The geometries in OpenSCAD won't do this in general, preferring to stay agnostic as to the output formats.

