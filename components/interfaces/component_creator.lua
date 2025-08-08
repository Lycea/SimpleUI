local comp_adder = ___simple_ui_base_class:extend()

------------------------------------------
---  ADD COMPONENTS
function comp_adder:AddSlider(value, x, y, width, height, min, max)
    local id = self:id()--#components.buttons +#components.slider  +1
    local temp = {}
    
    temp.id  = id
    temp.txt =  ""

    temp.color      = self:settings().button
    temp.ClickEvent = self.components.ClickEvent

    local tmp_slider = self.controls.s(temp)--- @type Slider

    tmp_slider:set_size(width , height )
    tmp_slider:set_pos(x, y)

    tmp_slider:set_bounds(min or 0, max or 100)
    tmp_slider:set_value(value or 0)

    self:add_component(tmp_slider, id)
    
    self:redraw()

    self:increase_id()
    return id
end

---
function comp_adder:AddSpinner(items, x, y, width, height, radius)
  local id = self:id()
  local temp = {}
  local w = self:settings().button.font:getWidth("test")
  local p = self:settings().button.font:getHeight()
  
  --iterate list and get largest string ...
  local w = 0
  for _, txt in pairs(items) do
    txt_size = self:settings().button.font:getWidth(txt)
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
  
  temp.color = self:settings().button
  temp.ClickEvent = self.components.ClickEvent
  
  --components[id] =spi:new(temp)
  self:add_component(self.controls.spi:new(temp), id)
  self:redraw()

  self:increase_id()
  return id
end


function comp_adder:AddNumericalSpinner(x, y, width, height, min, max)
    local id = self:id()
    local temp = {}
    local w = self:settings().button.font:getWidth("test")
    local p = self:settings().button.font:getHeight()

    --iterate list and get largest string ...
    local w = 0

    w = self:settings().button.font:getWidth(tostring(max))


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

    temp.color      = self:settings().button
    temp.ClickEvent = self.components.ClickEvent
    temp.numbers    = true

    temp.min        = min
    temp.max        = max

    --components[id] =spi:new(temp)
    self:add_component(self.controls.spi:new(temp), id)

    self:redraw()

    self:increase_id()
    return id
end

--- Add a label
function comp_adder:AddLabel(label, x, y)
    local id   = self:id()
    local temp = {}

    temp.id    = id
    temp.txt   = label or ""
    temp.x     = x or 0
    temp.y     = y or 0


    temp.color = self:settings().button
    local cmp  = self.controls.lb(temp)


    self:add_component(cmp, id)
    self:redraw()

    self:increase_id()
    return id
end


--- Add a Button
--- @param label string Name to display on the button
function comp_adder:AddButton(label,x,y,width,height,radius)
  local id = self:id()
  local temp = {}

  temp.id  = id
  temp.txt = label or ""

  print(self.name)
  temp.color      = self:settings().button
  temp.ClickEvent = self.components.ClickEvent


  local tmp_b = self.controls.b(temp)
  
  tmp_b:set_pos(x or 0, y or 0)
  tmp_b:set_size(width,height)

  tmp_b:recalc_size()

  self:add_component(tmp_b, id)
 
  self:increase_id()

  return id
end



--- Add a Draggable object
function comp_adder:AddDragable( x, y, width, height)
  print("adding dragable ~")
  local id        = self:id()
  local temp      = {}

  temp.id         = id

  temp.color      = self:settings().button
  temp.ClickEvent = self.components.ClickEvent


  local tmp_drag = self.controls.dr(temp)

  tmp_drag:set_pos(x or 0, y or 0)
  tmp_drag:set_size(width, height)

  self:add_component(tmp_drag, id)

  self:increase_id()

  return id
end



function comp_adder:AddToggleButton(label, x, y,w,h, value)
  local id        = self:id()
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

  temp.color      = self:settings().button
  temp.ClickEvent = self.components.ClickEvent

  --components[id] =cb:new(temp)

  local toggle_btn = self.controls.tb:new(temp)
  toggle_btn.ui = self

  self:add_component(toggle_btn, id)

  self:redraw()

  self:increase_id()
  return id
end


function comp_adder:AddCheckbox(label,x,y,value)
  local id = self:id()
  local temp = {}
  
  temp.id  = id
  temp.txt = label or ""
  temp.x   = x or 0
  temp.y   = y or 0
  
  temp.state = "default"
  temp.visible = true
  temp.checked = value or false
  
  temp.color      = self:settings().button
  temp.ClickEvent = self.components.ClickEvent
  
  --components[id] =cb:new(temp)
  local tmp_checkbox = self.controls.cb:new(temp)
  tmp_checkbox.ui = self
  self:add_component(tmp_checkbox, id)

  self:redraw()
  
  self:increase_id()
  return id
    
end



return comp_adder
