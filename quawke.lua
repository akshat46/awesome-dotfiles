local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local quawke = {}
local term
local options = {}
local client

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

quawke.init = function(terminal, o, fallback)
    fallback = fallback or false
    o = o or {}
    term = terminal
    options = o
    local workarea = awful.screen.focused().workarea
    local w = o.width or dpi(1200)
    local top_margin = o.top_margin or dpi(-10)
    local properties = {
        floating = true,
        sticky = true,
        ontop = true,
        focus = true,
        focussable = true,
        requests_no_titlebar = true,
        width = o.width or dpi(1200),
        x =   (workarea.width-w)/2,
        y = top_margin,
        height = o.height or dpi(400),
    }
    awful.spawn(terminal, properties, function(c)
        client = c
        c.hidden = not fallback
    end)
    collectgarbage()
end

quawke.toggle = function(c)
    if not pcall(function()
            if client.hidden then
                c.focus = client
                client:raise()
            end
            client.hidden = not client.hidden
        end) then
        quawke.init(term, options, true)
    end
    collectgarbage()
end

quawke.getClient = function() return client end

return quawke
