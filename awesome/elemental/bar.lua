local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local keys = require("keys")

local dock_autohide_delay = 0 -- seconds

local update_taglist = function (item, tag, index)
    if tag.urgent then
        item.fg = "#ffaa00"
        item.bg = "#00000000"
    elseif tag.selected then
        item.fg = colors.color15
        item.bg = "#00000000"
    elseif #tag:clients() > 0 then
        item.fg = colors.inactive
        item.bg = "#00000000"
    else
        item.fg = "#00000000"
        item.bg = "#00000000"
    end
end

local dock = require("noodle.dock")
local dock_placement = function(w)
    return awful.placement.bottom(w)
end

awful.screen.connect_for_each_screen(function(s)
    -- Create a taglist for every screen
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keys.taglist_buttons,
        layout = {
            spacing = 10,
            spacing_widget = {
                color  = '#00ff00',
                shape  = gears.shape.circle,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.align.horizontal,
        },
        widget_template = {
            widget = wibox.container.background,
            create_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
            update_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
        }
    }

    -- Create the taglist wibox
    s.taglist_box = awful.wibar({
        screen = s,
        visible = true,
        ontop = false,
        type = "dock",
        position = "top",
        height = dpi(32),
        -- position = "left",
        -- width = dpi(6),
        bg = colors.background .. "c0",
    })

    s.taglist_box:setup {
        widget = s.mytaglist,
    }

    -- Create the dock wibox
    s.dock = awful.popup({
        -- Size is dynamic, no need to set it here
        visible = false,
        bg = "#00000000",
        ontop = true,
        -- type = "dock",
        placement = dock_placement,
        widget = dock
    })
    dock_placement(s.dock)

    local popup_timer
    local autohide = function ()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
        popup_timer = gears.timer.start_new(dock_autohide_delay, function()
            popup_timer = nil
            s.dock.visible = false
        end)
    end

    -- Initialize wibox activator
    s.dock_activator = wibox({ screen = s, height = 1, bg = "#00000000", visible = true, ontop = false })
    awful.placement.bottom(s.dock_activator)
    s.dock_activator:connect_signal("mouse::enter", function()
        s.dock.visible = true
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    -- Keep dock activator below fullscreen clients
    local function no_dock_activator_ontop(c)
        if not s then 
            return
        elseif c.fullscreen then
            s.dock_activator.ontop = false
        else
            s.dock_activator.ontop = true
        end
    end
    client.connect_signal("focus", no_dock_activator_ontop)
    client.connect_signal("unfocus", no_dock_activator_ontop)
    client.connect_signal("property::fullscreen", no_dock_activator_ontop)

    -- s.dock_activator:buttons(
    --     gears.table.join(
    --         awful.button({ }, 4, function ()
    --             awful.tag.viewprev()
    --         end),
    --         awful.button({ }, 5, function ()
    --             awful.tag.viewnext()
    --         end)
    -- ))

    local function adjust_dock()
        -- Reset position every time the number of dock items changes
        dock_placement(s.dock)

        -- Adjust activator width every time the dock wibox width changes
        s.dock_activator.width = s.dock.width + dpi(250)
        -- And recenter
        awful.placement.bottom(s.dock_activator)
    end

    adjust_dock()
    s.dock:connect_signal("property::width", adjust_dock)

    s.dock:connect_signal("mouse::enter", function ()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    s.dock:connect_signal("mouse::leave", function ()
        autohide()
    end)
    s.dock_activator:connect_signal("mouse::leave", function ()
        autohide()
    end)

    -- -- Create a system tray widget
    -- s.systray = wibox.widget.systray()
    -- -- Create the tray box
    -- s.traybox = wibox({ screen = s, width = dpi(150), height = beautiful.wibar_height, bg = "#00000000", visible = false, ontop = true})
    -- s.traybox:setup {
    --     {
    --         {
    --             nil,
    --             s.systray,
    --             expand = "none",
    --             layout = wibox.layout.align.horizontal,
    --         },
    --         margins = dpi(10),
    --         widget = wibox.container.margin
    --     },
    --     bg = beautiful.bg_systray,
    --     shape = helpers.rrect(beautiful.border_radius),
    --     widget = wibox.container.background
    -- }
    -- awful.placement.bottom_right(s.traybox, { margins = beautiful.useless_gap * 2 })
    -- s.traybox:buttons(gears.table.join(
    --     awful.button({ }, 2, function ()
    --         s.traybox.visible = false
    --     end)
    -- ))
end)

awesome.connect_signal("elemental::dismiss", function()
    local s = mouse.screen
    s.dock.visible = false
end)

-- Every bar theme should provide these fuctions
function wibars_toggle()
    local s = awful.screen.focused()
    s.dock.visible = not s.dock.visible
end
-- function tray_toggle()
--     local s = awful.screen.focused()
--     s.traybox.visible = not s.traybox.visible
-- end
