-- package.path = package.path .. ";" .. "../Rogue/?.lua"
package.path = package.path .. ";" .. "../?.lua"
ui = require "../SimpleUI"


btn_1_click = 0
function button_1_cb()
  btn_1_click = btn_1_click +1
  ui.ObjSetValue(first_label_id, "txt", btn_1_click.." first button clicks"  )
end

btn_2_click = 0
function button_2_cb()
  btn_2_click = btn_2_click + 1
  ui.ObjSetValue(second_label_id, "txt", btn_2_click .. " first button clicks")
end


function cb_callback(id, name, checked)
  ui.ObjSetValue(id,"checkbox ",checked)
end


function button_examples()
  ------------------
  --button examples
  first_button_id = ui.AddButton("test_button", 20, 20, 50, 20)
  first_label_id = ui.AddLabel("test", 150, 20)
  ui.SetSpecialCallback(first_button_id, button_1_cb)


  second_button_id = ui.AddButton("test_button_two", 20, 50, 50, 20)
  second_label_id = ui.AddLabel("test", 150, 50)
  ui.SetSpecialCallback(second_button_id, button_2_cb)
end

function checkbox_examples()
  ------------------
  -- checkboxes
  first_cb = ui.AddCheckbox("my checkbox", 20, 80, 50)
  ui.SetSpecialCallback(first_cb, cb_callback)
end

function slider_examples()
  ------------------
  -- sliders

  -- ranged slider
  first_slider = ui.AddSlider(99,
    20, 110,
    200, 40,
    0, 50)

  -- label slider
  second_slider = ui.AddSlider(1,
    20, 150,
    200, 40,
    0, 10)

  lable_slider = ui.GetObject(second_slider)
  lable_slider.setCustomLabels(lable_slider, { "a", "b", "c" })

end

function spinner_examples()
    ------------------
    -- Spinner ?

    spinner_example = ui.AddNumericalSpinner(20, 200,
        30, 30, 0, 100)
end


function love.load()
  ui.init()

  button_examples()
  checkbox_examples()
  slider_examples()
  spinner_examples()

end

function love.update(dt)
  ui.update(dt)
end

function love.draw()
  ui.draw()
end


