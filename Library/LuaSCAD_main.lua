require "iuplua"
require "iupluacontrols"

res, name = iup.GetParam("Title", nil,
    "Give your name: %s\n","")

iup.Message("Hello!",name)
