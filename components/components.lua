print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("components.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

---- A file handling loading the modules and some helper functions for all modules.
---
---
--- !doctype module
--- @class components
local components = {
 lb  = require(BASE .. "Label"), --- @module "Label"
  b   = require(BASE .. 'Button'), --- @module "Button"
  s   = require(BASE .. 'Slider'), --- @module "Slider"
 cb  = require(BASE .. 'Checkbox'),--- @module "Checkbox"
 tb  = require(BASE .. "ToggleButton"), --- @module "ToggleButton"
 spi = require(BASE .. 'Spinner') --- @module "Spinner"
}

--import interfaces and extend classes


print("imported components")

--- @return components
return components

