-- package.path = package.path .. ";" .. "../Rogue/?.lua"
package.path = package.path .. ";" .. "../?.lua"

-- @module SimpleUI_
local ui = require("../SimpleUI")()



btn_1_click = 0
function button_1_cb()
  btn_1_click = btn_1_click +1
  ui:ObjSetValue(first_label_id, "txt", btn_1_click.." first button clicks"  )
end

btn_2_click = 0
function button_2_cb()
  btn_2_click = btn_2_click + 1
  ui:ObjSetValue(second_label_id, "txt", btn_2_click .. " first button clicks")
end

function cb_callback(id, name, checked)
  ui:ObjSetValue(id,"checkbox ",checked)
end

draggable_obj = nil

function button_examples()
  ------------------
  --button examples
  first_button_id = ui:AddButton("test_button", 20, 20, 50, 20)
  first_label_id = ui:AddLabel("test", 150, 20)
  print("button id",first_button_id)
  ui:SetSpecialCallback(first_button_id, button_1_cb)


  second_button_id = ui:AddButton("test_button_two", 20, 50, 50, 20)
  second_label_id = ui:AddLabel("test", 150, 50)
  ui:SetSpecialCallback(second_button_id, button_2_cb)
end

function checkbox_examples()
  ------------------
  -- checkboxes
  first_cb = ui:AddCheckbox("my checkbox", 20, 80, 50)
  ui:SetSpecialCallback(first_cb, cb_callback)
end

function slider_examples()
  ------------------
  -- sliders

  -- ranged slider
  first_slider = ui:AddSlider(99,
    20, 110,
    200, 40,
    0, 50)

  -- label slider
  second_slider = ui:AddSlider(1,
    20, 150,
    200, 40,
    0, 10)

  lable_slider = ui:GetObject(second_slider)
  lable_slider.setCustomLabels(lable_slider, { "a", "b", "c" })

end

function spinner_examples()
    ------------------
    -- Spinner ?

    spinner_example = ui:AddNumericalSpinner(20, 200,
        30, 30, 0, 100)
end


function toggle_example()

  ui:AddOptionGroup({
      ui:AddToggleButton("toggle", 300, 120, 50,50),
      ui:AddToggleButton("toggle", 370, 120, 50, 50),
      ui:AddToggleButton("toggle", 300, 175, 50, 50),
      ui:AddToggleButton("toggle", 370, 175, 50, 50)
  },"sample_tab_group")

  ui:AddOptionGroup({
    ui:AddCheckbox("c1", 440, 120, 50),
    ui:AddCheckbox("c2", 480, 120, 50),
    ui:AddCheckbox("c3", 440, 175, 50),
    ui:AddCheckbox("c4", 480, 175, 50),
  },"checkbox_toggles")

end

function component_group_example()
  function toggle_callback()
    print("cb trigger")
    ui:toggle_group_visibility("toggle_example")
  end

  toggle_x = 300

  toggle_checkbox = ui:AddCheckbox("group toggle", toggle_x, 20,true)
  ui:SetSpecialCallback(toggle_checkbox,toggle_callback,"onClick")

  toggle_group = {
     ui:AddButton("toggle_button_1", toggle_x, 50, 50, 20),
     ui:AddButton("toggle_button_2", toggle_x + 150, 50, 50, 20),
     ui:AddButton("toggle_button_3", toggle_x, 80, 50, 20),
     ui:AddButton("toggle_button_4", toggle_x + 150, 80, 50, 20),
  }

  ui:AddGroup(toggle_group,"toggle_example",true)
end

function draggable_example()
  draggable_obj = ui:GetObject(ui:AddDragable( 300, 200, 20,20))
end

function window_example()
  local win = ui:GetObject(ui:add_window(50, 300 , 200,200))
  win:AddButton("test",0,0, 50,30)
  win:AddCheckbox("test",0, 50, true)
end

function love.load()
  ui:init()

  button_examples()
  checkbox_examples()
  slider_examples()
  spinner_examples()
  toggle_example()
  draggable_example()

  component_group_example()

  window_example()
end

function love.update(dt)
  ui:update(dt)
end

function love.draw()

  -- love.graphics.print("move me" ,
  --                      draggable_obj.x - 10,
  --                      draggable_obj.y - draggable_obj.height    )


  ui:draw()
end


