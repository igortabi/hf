-- Copying the logic from the provided file and adapting it to the Atlantic.oce project
Find = gui.get_config_item
slider = gui.add_slider
switch = gui.add_checkbox
Show = gui.set_visible
combo = gui.add_combo
list = gui.add_listbox
selectable = gui.add_multi_combo
color_picker = gui.add_colorpicker
local tools = require("tools")
local elements = {}
local callbacks = {}
local login = {}
-- Loader print function
local loaderprint = function(status, text)
    local color
    if status == nil then
        color = render.color(255, 255, 255, 255) -- Neutral color
    elseif status == false then
        color = render.color(204, 0, 0, 255) -- Error color
    else
        color = render.color(51, 204, 51, 255) -- Success color
    end
    utils.print_console("[loader] ",color)
    utils.print_console(tostring(text), render.color(198, 203, 209, 255))
    utils.print_console("\n", render.color(198, 203, 209, 255))
end

-- Print function for Atlantic.oce
local print = function(text)
    utils.print_console("[Atlantic.oce] ", render.color(255, 255, 255, 255))
    utils.print_console(tostring(text), render.color(255, 255, 255, 255))
    utils.print_console("\n", render.color(255, 255, 255, 255))
end
-- Main script logic
local script = function()
    -- Creating GUI elements similar to the provided ASTRO logic
    local test1 = switch("test123", "lua>tab a")
    local test2 = list("test only2", "lua>tab a", 1, false, {"--------------------------------------------------"})

    -- Render function for conditional visibility
    elements.render = function()
        Show("lua>tab a>test only2", test1:get_bool())
    end

    -- Paint callback to render elements
    local on_paint = function()
        elements.render()
    end

    -- Registering the on_paint callback (adjust according to your environment)
    callbacks.init = function()
        if true then
            tools.add_callback("on_paint", on_paint)
        else
            print("Error: Callback registration function not found.")
        end
    end

    callbacks.init()
end

login.shit = true



login.check = function(trigger)
    loaderprint(nil, "[???] Connecting to server...")
    if not login.shit then
        loaderprint(false, "No user logon")
        return
    end
    loaderprint(true, "[$$$] Welcome Back " .. cvar["name"]:get_string() .. "! Loading Atlantic.oce...")
    utils.run_delayed(1000, function()
        script()
    end)
end

utils.run_delayed(1,function()
    login.check()
end)
