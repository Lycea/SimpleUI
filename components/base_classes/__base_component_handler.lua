--- !doctype module

--- @class BaseComponentHandler : __simple_ui_base_class
local base_component_handle = ___simple_ui_base_class:extend()

--base_component_handle.controls = require("components")

base_component_handle.g_id = 1 --- @type integer a increasing number for each component
base_component_handle.use_pre_11_colors = false
base_component_handle.focused = 0  --- @type integer the currently focused control, if none is focused it is 0
base_component_handle._redraw = true
base_component_handle.main_canvas = nil

function base_component_handle:new()
print("subinit!")
    self.components = {}
    self.component_ids = {}
end

function base_component_handle:redraw()
  base_component_handle._redraw = true
end

function base_component_handle:get_redraw()
  return base_component_handle._redraw
end

function base_component_handle:id()
  return base_component_handle.g_id
end

function base_component_handle:increase_id()
  base_component_handle.g_id = self:id() + 1
end


function base_component_handle:settings()

  pre_11_colors = {
    --      border col             background       label/font                 hover   clicked
    button = {
      border_color  = { 255, 255, 255, 255 },
      default_color = { 0, 0, 0, 0, 255 },
      font_color    = { 255, 255, 255, 255 },
      hover_color   = { 50, 50, 50, 250 },
      clicked_color = { 0, 50, 0, 255 },
      toggled_color = { 50, 50, 0 ,255 },
      font          = self.font
    }
  }

  post_11_colors = {
    --      border col             background       label/font                 hover   clicked
    button = {
      border_color  = { 255 / 255, 255 / 255, 255 / 255, 255 / 255 },
      default_color = { 0, 0, 0, 0, 255 / 255 },
      font_color    = { 255 / 255, 255 / 255, 255 / 255, 255 / 255 },
      hover_color   = { 50 / 255, 50 / 255, 50 / 255, 250 / 255 },
      clicked_color = { 0, 50 / 255, 0, 255 / 255 },
      toggled_color = { 50 /255 , 50/255 , 0, 250/255},
      font          = self.font
    }
  }

  return base_component_handle.use_pre_11_colors and pre_11_colors or post_11_colors

end


function base_component_handle:add_component(comp, id)
  print("adding stuff",comp,id)
  self.components[id] = comp
  table.insert(self.component_ids, id)

  self:redraw()
end
lg = love.graphics


function base_component_handle:draw()
  if self:get_redraw() then
    lg.setCanvas(base_component_handle.main_canvas)
    lg.clear(0, 0, 0, 0)
    --print(#components)
    for _, i in pairs(self.component_ids) do
      if self.components[i] then
        self.components[i]:draw()
      end
    end

    lg.setCanvas()
  end
  lg.draw(base_component_handle.main_canvas, 0, 0)
  base_component_handle._redraw = false
end


function base_component_handle:update(dt)
  self:check_components()
end

function base_component_handle:GetValue(element_id)
end

function base_component_handle:check_components()
  local x, y = love.mouse.getX(), love.mouse.getY()
  local clicked = love.mouse.isDown(1)
  local draw

  for _, i in pairs(self.component_ids) do
    -- TODO do better iterating than all of the items
    --print("DEBUG: id checks ",i)
    if self.components[i] then
      base_component_handle.focused , draw = self.components[i]:update(clicked, x, y, base_component_handle.focused)

      if self:get_redraw() == true then  else base_component_handle._redraw = draw end
    end
  end
end



------------
----- component settings
function base_component_handle:SetColor(component,color_type,color)
  self.settings[component][color_type] = color
  self:redraw()
end


--- @deprecated Only available right now till I switch it to the other correctly written one
function base_component_handle:SetVisibiliti(id, visible)
  self:SetVisibility(id, visible)
end

---- function to set the visibility of a control
function base_component_handle:SetVisibility(id, visible)
  self.components[id].visible = visible
  if self.components[id].SetVisibility then self.components[id]:SetVisibility(visible) end

  self:redraw()
end


function base_component_handle:SetEnabled(id, enabled)
  self.components[id].enabled = enabled
  if self.components[id].SetEnabled then self.components[id]:SetEnabled(enabled) end
  
  base_component_handle._redraw = false
end

function base_component_handle:SetSpecialCallback(id, fn, event_to_set)

  print("callback info",id,fn)
  self.components[id].ClickEvent = fn

  print(self.components)
  self:__SetEventCallback(id, fn, event_to_set or "onClick")
end

function base_component_handle:__SetEventCallback(id, fn, event_name)
  print("info",id,fn)
  self.components[id]:setCallback(event_name, fn)
end


function base_component_handle:init()
 self.font = love.graphics.getFont()
    base_component_handle.main_canvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
    self.controls.spi.set_btn(self.controls.b)
    self.components.ClickEvent = function () end
end

function base_component_handle:UnsetFocus()
  base_component_handle.focused = 0
end

function base_component_handle:RemoveComponent(id)
  if not pcall(self.components[id].destruct) then
    print("no special destruct function for ",self.components[id].name,id)
  end

  for _,saved_id in pairs(self.component_ids) do
    if saved_id == id then
      self.component_ids[_] = nil

      if id == base_component_handle.focused then
        self:UnsetFocus()
      end

      break
    end
  end

  self.components[id] = nil
end

function base_component_handle:GetObject(id)
  if self.components[id] == nil then
    print("Object with id " .. id .. "was not found in this ui")

    return -1
  end

  return self.components[id]
end

function base_component_handle:ObjSetValue(id,variable,value)
  if self.components[id] == nil then
    print("Object with id "..id.."was not found in this ui")

    return -1
  end

  self.components[id][variable] = value
end


function base_component_handle:set_pre_11_colors()
  base_component_handle.use_pre_11_colors = true
end


return base_component_handle
