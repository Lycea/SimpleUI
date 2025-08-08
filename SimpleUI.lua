local BASE = (...)..'.'
print(BASE)
local i= BASE:find("SimpleUI.$")
print (i)
BASE=BASE:sub(1,i-1)
print(BASE)


--- !doctye module



___simple_ui_base_helpers = {}



--- @class __simple_ui_base_class : classic
___simple_ui_base_class = require(BASE .. "base_class.classic")


--- @alias ui.controls components
--- @module "components.components"
local controls = require(BASE .. "components.components")

--- @module "components.base_classes.__base_component_handler"
local base_handler = require(BASE .. "components.base_classes.__base_component_handler")
base_handler.controls = controls

---- My simple ui module.
---
--- !doctype module
--- @class SimpleUI_ : BaseComponentHandler 
local ui = base_handler:extend()
ui:implement(require(BASE .. "components.interfaces.component_creator"))
ui.controls = controls
ui:implement(  require(BASE .. "components.interfaces.groups"))



function ui:add_window(x, y, w, h)
  local id = self:id()

  local tmp = {}
  local window = self.controls.wi(tmp)

  window:set_size(w,h)
  window:set_pos(x,y)

  self:add_component(window,id)

  self:increase_id()
  self:redraw()

  return id
end



-- ui.controls.cb.ui = ui
-- ui.controls.tb.ui = ui

return ui
