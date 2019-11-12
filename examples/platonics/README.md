# Platonic Solids

Tetrahedron<br/>
![Tetrahedron](images/tetrahedron.PNG?raw=true)
```lua
package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local t = platonics.Tetrahedron({radius = 20});

local f = assert(io.open("tetrahedron.scad", 'w'));
oscad.PolyMesh_print(f,t:getMesh())
f:close()
```

Octahedron<br/>
![Octahedron](images/octahedron.PNG?raw=true)
```lua
package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local t = platonics.Octahedron({radius = 20});

local f = assert(io.open("octahedron.scad", 'w'));
oscad.PolyMesh_print(f,t:getMesh())
f:close()
```

Hexahedron<br/>
![Hexahedron](images/hexahedron.PNG?raw=true)
```lua
package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local p = platonics.Hexahedron({radius = 20});

local f = assert(io.open("hexahedron.scad", 'w'));
oscad.PolyMesh_print(f,p:getMesh())
f:close()
```

Icosahedron<br/>
![Icosahedron](images/icosahedron.PNG?raw=true)
```lua
package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local p = platonics.Icosahedron({radius = 20});

local f = assert(io.open("icosahedron.scad", 'w'));
oscad.PolyMesh_print(f,p:getMesh())
f:close()
```


Dodecahedron<br/>
![Dodecahedron](images/dodecahedron.PNG?raw=true)<br/>
```lua
package.path = "../?.lua;../../?.lua;"..package.path

local platonics = require ("lmodel.platonics")
local oscad = require "lmodel.openscad_print"

local t = platonics.Dodecahedron({radius = 20});

local f = assert(io.open("dodecahedron.scad", 'w'));
oscad.PolyMesh_print(f,t:getMesh())
f:close()
```