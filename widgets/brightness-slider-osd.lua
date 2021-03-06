local wibox = require('wibox')
local mat_list_item = require('widgets.list-item')
local mat_slider = require('widgets.slider')
local mat_icon_button = require('widgets.icon-button')
local clickable_container = require('widgets.clickable-container')
local icons = require('icons')
local watch = require('awful.widget.watch')
local spawn = require('awful.spawn')
local awful = require('awful')

-- macbook brightness
local percent = 100/420

local slider_osd =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

slider_osd:connect_signal(
  'property::value',
  function()
    spawn('xbacklight -set ' .. math.max(slider_osd.value, 5), false)
  end
)

slider_osd:connect_signal(
  'button::press',
  function()
    slider_osd:connect_signal(
      'property::value',
      function()
        toggleBriOSD(true)
      end
    )
  end
)

function UpdateBriOSD()
  awful.spawn.easy_async("cat /sys/class/backlight/gmux_backlight/brightness", function( stdout )
    local brightness = string.match(stdout, '(%d+)')
    slider_osd:set_value(tonumber(brightness)*percent)
  end, false)
end


local icon =
  wibox.widget {
  image = icons.brightness,
  widget = wibox.widget.imagebox
}

local button = mat_icon_button(icon)

local brightness_setting_osd =
  wibox.widget {
  button,
  slider_osd,
  widget = mat_list_item
}

return brightness_setting_osd
