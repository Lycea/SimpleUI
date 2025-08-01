

local BASE = (...)..'.'
print(BASE)
local i= BASE:find("SimpleUI.$")
print (i)
BASE=BASE:sub(1,i-1)
print(BASE)

-- local lb  = require(BASE.."Label")
-- local b   = require(BASE..'Button')
-- local s   = require(BASE..'Slider')
-- local cb  = require(BASE..'Checkbox')
-- local tb  = require(BASE.."ToggleButton")

-- local spi = require(BASE..'Spinner')


___simple_ui_base_helpers = {}



--- @class __simple_ui_base_class : classic
___simple_ui_base_class = require(BASE .. "base_class.classic")


--- @alias ui.controls components
--- @module "components.components"
local controls = require(BASE .. "components.components")


---- My simple ui module.
---
--- !doctype module
--- @class SimpleUI
local ui = {}

--- all controls that exist at the moment
local components = {}

--- @class list of all component ids in the ui
local component_ids = {}

local redraw = true
local main_canvas 

local focused = 0

local g_id = 1

local groups ={ }
local toggle_groups = {}

local font = nil

local lg = love.graphics

local use_pre_11_colors = false

controls.cb.ui = ui
controls.tb.ui = ui

--- function which returns the color settings based on love2d version set
local function settings()

  pre_11_colors = {
    --      border col             background       label/font                 hover   clicked
    button = {
      border_color  = { 255, 255, 255, 255 },
      default_color = { 0, 0, 0, 0, 255 },
      font_color    = { 255, 255, 255, 255 },
      hover_color   = { 50, 50, 50, 250 },
      clicked_color = { 0, 50, 0, 255 },
      toggled_color = { 50, 50, 0 ,255 },
      font          = font
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
      font          = font
    }
  }

  return use_pre_11_colors and pre_11_colors or post_11_colors

end
--- private function to add a new component to the list
local function add_component(comp,id)
  components[id] = comp
  table.insert(component_ids,id)

  redraw = true
end

local function increase_id()
  g_id = g_id+1
end




function init()
  --spi.set_btn(b)
end

--- draw the ui
function ui.draw()
  if redraw then
    lg.setCanvas(main_canvas)
    lg.clear(0,0,0,0)
    --print(#components)
    for _,i in pairs(component_ids)  do
      if components[i] then
        components[i]:draw()
      end
    end
    
    lg.setCanvas()
  end
  lg.draw(main_canvas,0,0)
end


-----------------------
-- component groups
function ui.AddGroup(tab_ids,name,visibility)
  groups[name] = {}
  groups[name].ids =tab_ids
  groups[name].__visible = visibility

  if visibility == false then
      ui.SetGroupVisible(name,false)
  end

end


function ui.SetGroupVisible(name,visible)
  --iterate over ids
  groups[name].__visible = visible
  for k,v in pairs(groups[name].ids) do
    ui.SetVisibiliti(v,visible)
  end
  
end

function ui.toggle_group_visibility(name)
  ui.SetGroupVisible(name, not groups[name].__visible)
end


----------------------
-- toggle group / option groups


local function set_toggle_group(id, group)
  components[id].toggle_group = group
end


function ui.update_toggles(enabled_id,group)
  for _,id in pairs(toggle_groups[group].ids) do
    if id ~= enabled_id then
--      print(id,enabled_id)
    
      --components[id].checked = false
      components[id]:toggle(false)
      redraw = true
    end
  end
end

function ui.AddOptionGroup(tab_ids,name,allow_non_selected)
  toggle_groups[name] = {}
  toggle_groups[name].ids = tab_ids
  toggle_groups[name].allow_non_selected = allow_non_selected or true

  for _,id in pairs(tab_ids) do
    set_toggle_group(id, name)
  end
  
end

function ui.AddToOptionGroup(id,name)
  table.insert(toggle_groups[name].ids, id )
end


-------------------------

function ui.GetValue(element_id)
  if components[element_id] ~= nil then
    if components[element_id].GetValue ~= nil then
      return components[element_id]:GetValue()
    else
      assert(false, "The element does not support GetValue()")
    end
  else
    assert(false, "The element with the given id does not exist")
  end
end



local function check_components()
  local x,y = love.mouse.getX(),love.mouse.getY()
  local clicked = love.mouse.isDown(1)
  local draw 

  for _,i in pairs(component_ids) do
    -- TODO do better iterating than all of the items
    --print("DEBUG: id checks ",i)
    if components[i] then
      focused , draw = components[i]:update(clicked,x,y,focused)
    
      if redraw == true then  else redraw = draw end
    end
  end
  
end


function ui.AddClickHandle(callback)
  --components.ClickEvent = callback
end

--- Update the ui
function ui.update()
  check_components()
end

------------------------------------------
---  ADD COMPONENTS
function ui.AddSlider(value,x,y,width,height,min,max)
    local id = g_id--#components.buttons +#components.slider  +1
    local temp = {}
    
    temp.id  = id
    temp.txt =  ""

    temp.color      = settings().button
    temp.ClickEvent = components.ClickEvent

    local tmp_slider = controls.s(temp)--- @type Slider

    tmp_slider:set_size(width , height )
    tmp_slider:set_pos(x, y)

    tmp_slider:set_bounds(min or 0, max or 100)
    tmp_slider:set_value(value or 0)

    add_component(tmp_slider, id)
    
    redraw = true

    increase_id()
    return id
end

---
function ui.AddSpinner(items,x,y,width,height,radius)
  local id = g_id
  local temp = {}
  local w = settings().button.font:getWidth("test")
  local p = settings().button.font:getHeight()
  
  --iterate list and get largest string ...
  local w = 0
  for _, txt in pairs(items) do
    txt_size = settings().button.font:getWidth(txt)
    if txt_size > w then w = txt_size end
  end

  temp.items = items or {}
  temp.id  = id
  temp.txt = label or ""

  --position
  temp.x   = x or 0
  temp.y   = y or 0

  width = w
  height = p

  temp.width = width or 50
  temp.height = height or 30

  temp.txt_pos = {}
  
  x = math.floor(x+( width - w)/2)
  y = math.floor(y+( height -p)/2)
  
  temp.txt_pos.x = x + 10
  temp.txt_pos.y = y 
  
  temp.state = "default"
  temp.visible = true
  
  temp.color = settings().button
  temp.ClickEvent = components.ClickEvent
  
  --components[id] =spi:new(temp)
  add_component(controls.spi:new(temp), id)
  redraw = true
  
  g_id =g_id +1
  return id
end

---
function ui.AddNumericalSpinner(x, y, width, height, min, max)
    local id = g_id
    local temp = {}
    local w = settings().button.font:getWidth("test")
    local p = settings().button.font:getHeight()

    --iterate list and get largest string ...
    local w = 0

    w = settings().button.font:getWidth(tostring(max))


    temp.items      = items or {}
    temp.id         = id
    temp.txt        = label or ""

    --position
    temp.x          = x or 0
    temp.y          = y or 0

    width           = w
    height          = p

    temp.width      = width or 50
    temp.height     = height or 30

    temp.txt_pos    = {}

    x               = math.floor(x + (width - w) / 2)
    y               = math.floor(y + (height - p) / 2)

    temp.txt_pos.x  = x + 10
    temp.txt_pos.y  = y

    temp.state      = "default"
    temp.visible    = true

    temp.color      = settings().button
    temp.ClickEvent = components.ClickEvent
    temp.numbers    = true

    temp.min        = min
    temp.max        = max

    --components[id] =spi:new(temp)
    add_component(controls.spi:new(temp), id)

    redraw = true

    g_id = g_id + 1
    return id
end

--- Add a label
function ui.AddLabel(label, x, y)
    local id   = g_id
    local temp = {}

    temp.id    = id
    temp.txt   = label or ""
    temp.x     = x or 0
    temp.y     = y or 0


    temp.color = settings().button
    local cmp  = controls.lb(temp)


    add_component(cmp, id)
    redraw = true

    increase_id()
    return id
end


--- Add a Button
--- @param label string Name to display on the button
function ui.AddButton(label,x,y,width,height,radius)
  local id = g_id
  local temp = {}

  temp.id  = id
  temp.txt = label or ""

  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent


  local tmp_b = controls.b(temp)
  
  tmp_b:set_pos(x or 0, y or 0)
  tmp_b:set_size(width,height)

  tmp_b:recalc_size()

  add_component(tmp_b, id)
 
  increase_id()

  return id
end



--- Add a Draggable object
function ui.AddDragable( x, y, width, height)
  local id        = g_id
  local temp      = {}

  temp.id         = id

  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent


  local tmp_drag = controls.dr(temp)

  tmp_drag:set_pos(x or 0, y or 0)
  tmp_drag:set_size(width, height)

  add_component(tmp_drag, id)

  increase_id()

  return id
end



function ui.AddToggleButton(label, x, y,w,h, value)
  local id        = g_id
  local temp      = {}

  temp.id         = id
  temp.txt        = label or ""

  temp.x          = x or 0
  temp.y          = y or 0
  temp.w          = w or 0
  temp.h          = h or 0

  temp.state      = "default"
  temp.visible    = true
  temp.checked    = value or false

  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent

  --components[id] =cb:new(temp)
  add_component(controls.tb:new(temp), id)

  redraw = true

  g_id = g_id + 1
  return id
end


function ui.AddCheckbox(label,x,y,value)
  local id = g_id
  local temp = {}
  
  temp.id  = id
  temp.txt = label or ""
  temp.x   = x or 0
  temp.y   = y or 0
  
  temp.state = "default"
  temp.visible = true
  temp.checked = value or false
  
  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent
  
  --components[id] =cb:new(temp)
  add_component(controls.cb:new(temp), id)
  
  redraw = true
  
  g_id =g_id +1
  return id
    
end

------------
----- component settings
function ui.SetColor(component,color_type,color)
  settings[component][color_type] = color
  redraw = true
end


--- @deprecated Only available right now till I switch it to the other correctly written one
function ui.SetVisibiliti(id, visible)
  ui.SetVisibility(id, visible)
end

---- function to set the visibility of a control
function ui.SetVisibility(id, visible)
  components[id].visible = visible
  if components[id].SetVisibility then components[id]:SetVisibility(visible) end

  redraw = true
end


function ui.SetEnabled(id, enabled)
  components[id].enabled = enabled
  if components[id].SetEnabled then components[id]:SetEnabled(enabled) end

  redraw = false
end

function ui.SetSpecialCallback(id, fn, event_to_set)
  components[id].ClickEvent = fn

  ui.__SetEventCallback(id, fn, event_to_set or "onClick")
end

function ui.__SetEventCallback(id, fn, event_name)
  components[id]:setCallback(event_name, fn)
end


function ui.init()
 font = love.graphics.getFont()
    main_canvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
    controls.spi.set_btn(controls.b)
    components.ClickEvent = function () end
end

function ui.UnsetFocus()
  focused = 0
end

function ui.RemoveComponent(id)
  if not pcall(components[id].destruct) then
    print("no special destruct function for ",components[id].name,id)
  end

  for _,saved_id in pairs(component_ids) do
    if saved_id == id then
      component_ids[_] = nil

      if id == focused then
        ui.UnsetFocus()
      end

      break
    end
  end

  components[id] = nil
end

function ui.RemoveGroup(name)
  groups[name] = nil
end


function ui.GetObject(id)
    return components[id]
end

function ui.ObjSetValue(id,variable,value)
  components[id][variable] = value
end


function ui.set_pre_11_colors()
  use_pre_11_colors = true
end

init()

return ui
