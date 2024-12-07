local BASE = (...)..'.' 
print(BASE)
local i= BASE:find("SimpleUI.$")
print (i)
BASE=BASE:sub(1,i-1)
print(BASE)

local lb  = require(BASE.."Label")
local b   = require(BASE..'Button')
local s   = require(BASE..'Slider')
local cb  = require(BASE..'Checkbox')

local spi = require(BASE..'Spinner')


local ui = {}

local components ={}
local component_ids = {}

local redraw = true
local main_canvas 

local focused = 0

local g_id = 1

local groups ={ }

local font = nil

local lg = love.graphics

local function settings()
  return {
    --      border col             background       label/font                 hover   clicked
    button = {
      border_color  = { 255, 255, 255, 255 },
      default_color = { 0, 0, 0, 0, 255 },
      font_color    = { 255, 255, 255, 255 },
      hover_color   = { 50, 50, 50, 250 },
      clicked_color = { 0, 50, 0, 255 },
      font          = font
    }
  }
end

local function add_component(comp,id)
  components[id] = comp
  table.insert(component_ids,id)
end


function init()
  --spi.set_btn(b)
end
  
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


function ui.AddGroup(tab_ids,name,visibility)
  groups[name] = {}
  groups[name].ids =tab_ids

  if visibility == false then
      ui.SetGroupVisible(name,false)
  end

end


function ui.SetGroupVisible(name,visible)
  --iterate over ids
  for k,v in pairs(groups[name].ids) do
    ui.SetVisibiliti(v,visible)
  end
  
end


function ui.GetValue(element_id)
  if components[element_id] ~= nil then
    if components[element_id].GetValue ~= nil then
      return components[element_id]:GetValue()
    else
      assert(false,"The element does not support GetValue()")
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

function ui.update()
  check_components()
end

------------------------------------------
---  ADD COMPONENTS
function ui.AddSlider(value,x,y,width,height,min,max)
    local id = g_id--#components.buttons +#components.slider  +1
    local temp = {}
    
    temp.id  = id
    temp.txt = label or ""
    temp.x   = x or 0
    temp.y   = y or 0
    temp.width = width or 50
    temp.height = height or 30
    temp.txt_pos = {}
    

    
    temp.state = "default"
    temp.visible = true
    
    temp.sli_pos = {}
    temp.sli_pos.x =temp.x+temp.width/2 -10
    temp.sli_pos.y =temp.y+temp.height/2 -10
    temp.sli_pos.h = 20
    temp.sli_pos.w = 20
    
    --love.graphics.rectangle(mode,obj.x+20,y,obj.width - 40,6)
    temp.txt_pos.x = (temp.x + 20) + temp.width -40 +10
    temp.txt_pos.y = temp.sli_pos.y + 7
    
    temp.value  = value or 0
    temp.min    = min   or 0
    temp.max    = max   or 100
    
    temp.color = settings().button
    temp.ClickEvent = components.ClickEvent

    add_component(s:new(temp), id)
    --components[id] =
    --table.insert( component_ids, id)
    
    redraw = true
    g_id=g_id +1
    return id
end

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
  add_component(spi:new(temp), id)
  redraw = true
  
  g_id =g_id +1
  return id
end

function ui.AddNumericalSpinner(x,y,width,height,min,max)
  local id = g_id
  local temp = {}
  local w = settings().button.font:getWidth("test")
  local p = settings().button.font:getHeight()
  
  --iterate list and get largest string ...
  local w = 0

  w = settings().button.font:getWidth(tostring(max))


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
  
  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent
  temp.numbers = true

  temp.min = min
  temp.max = max

  --components[id] =spi:new(temp)
  add_component(spi:new(temp), id)

  redraw = true
  
  g_id =g_id +1
  return id
end

function ui.AddLabel(label,x,y)
  local id = g_id
  local temp = {}
  
  temp.id  = id
  temp.txt = label or ""
  temp.x   = x or 0
  temp.y   = y or 0
  
  temp.state = "default"
  temp.visible = true
  
  temp.color   = settings().button
  
  add_component(lb:new(temp), id)
  redraw = true
  
  g_id =g_id +1
  return id
    
end

function ui.AddButton(label,x,y,width,height,radius)
  local id = g_id
  local temp = {}
  local w         = settings().button.font:getWidth(label)
  local p = settings().button.font:getHeight()
  
  temp.id  = id
  temp.txt = label or ""
  temp.x   = x or 0
  temp.y   = y or 0

  width = w > width and w+20 or width
  height = p> height and p*3 or height
  temp.width = width or 50
  temp.height = height or 30
  temp.txt_pos = {}
  
  x =math.floor(x+( width - w)/2)
  y = math.floor(y+( height -p)/2)
  
  temp.txt_pos.x = x--x + 10
  temp.txt_pos.y = y--y + 7
  
  temp.state = "default"
  temp.visible = true
  
  temp.color      = settings().button
  temp.ClickEvent = components.ClickEvent
  
  add_component(b:new(temp), id)
  
  redraw = true
  
  g_id =g_id +1
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
  add_component(cb:new(temp), id)
  
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

function ui.SetVisibiliti(id,visible)
  components[id].visible =    visible  
  if components[id].SetVisibility then  components[id]:SetVisibility(visible) end

  redraw = true
end

function ui.SetEnabled(id, enabled)
  components[id].enabled = enabled
  if components[id].SetEnabled then components[id]:SetEnabled(enabled) end

  redraw = false
end

function ui.SetSpecialCallback(id, fn, event_to_set)
  components[id].ClickEvent = fn

  ui.SetEventCallback(id, fn, event_to_set or "onClick")
end

function ui.SetEventCallback(id, fn, event_name)
  components[id]:setCallback(event_name, fn)
end


function ui.init()
 font = love.graphics.getFont()
    main_canvas = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())
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


init()

return ui
