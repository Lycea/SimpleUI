print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("Layouts.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)
print("importing layouts")
---- A file handling loading the modules and some helper functions for all modules.
---
---
--- !doctype module
--- @class layouts
local layouts = {
  vertical     = require(BASE .. 'Vertical'), --- @module "Vertical"
  horizontal      = require(BASE .. 'Horizontal'), --- @module "Horizontal"
  grid      = require(BASE .. 'Grid'),  --- @module "Grid"
}

--import interfaces and extend classes

print("imported components")

--- @return layouts
return layouts
