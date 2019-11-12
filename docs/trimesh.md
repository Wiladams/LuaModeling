# trimesh - lmodel.trimesh

A Triangle Mesh is a core data structure for LuaModeling.  It is a table with the following fields:
* vertices - list of vertices in the mesh.  Each vertex has x,y,z as simple array indices, 1, 2, 3

* faces - list of faces.  Each face is a combination of indices of at least 3 vertices.

* edges - a list of edges.  Each edge is a combination of two vertices and two faces. This field is not currently in usage.

A trimesh can be constructed from the beginning with a list of vertices and faces.

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
```

A mesh can also be constructed in a piecewise manner, by adding vertices and faces along the way.

```lua
local mesh = TriangleMesh:new()
mesh:addvertex({0,0,0})
mesh:addvertex({10,0,0})
mesh:addvertex({10,10,0})
mesh:addvertex({0, 10, 0})

mesh:addface({1,2,3})
mesh:addface({1,3,4})
```

In either case, the same exact mesh is created, which results in the following.

![trimesh1](images/trimesh1.PNG?raw=true)

All other models are built upon this core mesh object.  If you want to build your own models from the ground up, you will want to become familiar with the constructor and two functions (addvertex, addface) of the TriangleMesh.