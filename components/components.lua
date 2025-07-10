print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("components.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)

local components = { lb  = require(BASE .. "Label"),
  b   = require(BASE .. 'Button'),
 s   = require(BASE .. 'Slider'),
 cb  = require(BASE .. 'Checkbox'),
 tb  = require(BASE .. "ToggleButton"),
 spi = require(BASE .. 'Spinner')
}


print("imported components")
return components

