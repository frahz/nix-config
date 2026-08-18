hl.monitor({
  output = "HDMI-A-1",
  mode = "2560x1440@143.91",
  position = "0x0",
  scale = "auto",
})

hl.env("XCURSOR_SIZE", cursorSize)

hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    accel_profile = "flat",
    touchpad = {
      natural_scroll = false,
    },
  },
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 0,
    col = {
      active_border = "rgba(88888888)",
      inactive_border = "rgba(00000088)",
    },
    layout = "dwindle",
  },
  decoration = {
    rounding = 5,
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      new_optimizations = true,
    },
    shadow = {
      color = "rgba(00000099)",
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  cursor = {
    hide_on_key_press = true,
  },
  misc = {
    disable_hyprland_logo = true,
    focus_on_activate = true,
  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "slide" })

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.exit())

hl.bind("ALT + Space", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("BEMOJI_PICKER_CMD='" .. fuzzel .. " --dmenu' bemoji"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(hyprlock))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("powermenu"))

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("firefox --private-window"))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker --autocopy --no-fancy --format=hex"))

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("screenshot"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot-edit"))

hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))

hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -60, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 60, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -60, relative = true }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 60, relative = true }))

for workspace = 1, 10 do
  local key = workspace % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.group.prev())

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "satty",
  match = { class = "^(com.gabm.satty)$" },
  float = true,
  size = { "monitor_w * 0.4", "monitor_h * 0.6" },
  min_size = { 600, 400 },
})

hl.window_rule({
  name = "firefox-picture-in-picture",
  match = {
    class = "^(firefox)$",
    title = "^(Firefox|Picture-in-Picture)$",
  },
  float = true,
  pin = true,
  keep_aspect_ratio = true,
})

hl.window_rule({
  name = "jellyfin-media-player",
  match = { class = "^(Jellyfin Media Player)$" },
  tile = true,
})

hl.window_rule({
  name = "gnome-calculator",
  match = { class = "^(org.gnome.Calculator)$" },
  float = true,
})

hl.window_rule({
  name = "mdrop",
  match = { title = "^(mdrop)$" },
  float = true,
})

local function centeredFloatRule(name, match)
  hl.window_rule({
    name = name,
    match = match,
    center = true,
    float = true,
    size = { "monitor_w * 0.4", "monitor_h * 0.6" },
  })
end

centeredFloatRule("pwvucontrol", { class = "(com.saivert.pwvucontrol)" })
centeredFloatRule("open-files", { initial_title = "(Open Files)" })
centeredFloatRule("bluetooth-devices", { initial_title = "(Bluetooth Devices)" })
