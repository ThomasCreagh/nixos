-- Hyprland config, loaded from the hyprland.lua that Home Manager generates.
-- API reference: share/hypr/stubs/hl.meta.lua in the Hyprland package.

local mod = "SUPER"
local terminal = "ghostty"
local fileManager = "dolphin"
local webBrowser = "firefox"
local menu = "wofi --show drun"

local laptop = "eDP-1"
local laptopWorkspaces = { 3, 4, 5, 10 }
local externalWorkspaces = { 1, 2, 6, 7, 8, 9 }

------------------------------------------------------------------------------
-- Monitors
------------------------------------------------------------------------------

-- The laptop stays at the origin and any external display is stacked above
-- it, centred horizontally.
hl.monitor({ output = laptop, mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto-center-up", scale = 1 })

------------------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------------

for i, ws in ipairs(laptopWorkspaces) do
	hl.workspace_rule({ workspace = tostring(ws), monitor = laptop, default = i == 1 })
end

-- Pin externalWorkspaces to the first non-laptop monitor and move any that
-- already exist onto it. Without an external monitor they fall back to the
-- laptop. Runs on every config load and whenever a monitor is plugged in.
local function pinExternalWorkspaces()
	local external
	for _, m in ipairs(hl.get_monitors()) do
		if m.name ~= laptop then
			external = m.name
			break
		end
	end
	if not external then
		return
	end

	for i, ws in ipairs(externalWorkspaces) do
		hl.workspace_rule({ workspace = tostring(ws), monitor = external, default = i == 1 })
		if hl.get_workspace(ws) then
			hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = external }))
		end
	end
end

pinExternalWorkspaces()
hl.on("monitor.added", pinExternalWorkspaces)

------------------------------------------------------------------------------
-- Look and feel
------------------------------------------------------------------------------

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 4,
	},
	decoration = {
		rounding = 6,
		blur = {
			enabled = true,
			size = 8,
			passes = 2,
		},
	},
	animations = {
		enabled = false,
	},
	input = {
		kb_layout = "us",
		touchpad = {
			natural_scroll = true,
		},
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

------------------------------------------------------------------------------
-- Window rules
------------------------------------------------------------------------------

-- claude-desktop runs inside a bwrap FHS wrapper, so the startup rule below
-- doesn't reliably catch its window; match on class instead.
hl.window_rule({
	name = "claude-workspace",
	match = { class = "^(com\\.anthropic\\.Claude)$" },
	workspace = "4 silent",
})

-- nmtui/bluetui opened from waybar
hl.window_rule({
	name = "floating-tuis",
	match = { class = "^(tui\\..*)$" },
	float = true,
	size = "1000 650",
	center = true,
})

------------------------------------------------------------------------------
-- Startup
------------------------------------------------------------------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("wbg ~/.dotfiles/wallpapers/3.jpg")
	hl.exec_cmd("ai")
	hl.exec_cmd("mako")
	-- These rules only apply to the window spawned here, so later windows
	-- open on whatever workspace is active.
	hl.exec_cmd(terminal, { workspace = "1 silent" })
	hl.exec_cmd(webBrowser, { workspace = "2 silent" })
	hl.exec_cmd("thunderbird", { workspace = "3 silent" })
	hl.exec_cmd("claude-desktop", { workspace = "4 silent" })
	hl.exec_cmd("signal-desktop", { workspace = "5 silent" })
	hl.exec_cmd("obsidian", { workspace = "6 silent" })
end)

------------------------------------------------------------------------------
-- Keybinds
------------------------------------------------------------------------------

local function bind(keys, dispatcher, opts)
	hl.bind(mod .. " + " .. keys, dispatcher, opts)
end

-- Apps
bind("Q", hl.dsp.exec_cmd(terminal))
bind("W", hl.dsp.exec_cmd(webBrowser))
bind("Y", hl.dsp.exec_cmd("spotify"))
bind("O", hl.dsp.exec_cmd("obsidian"))
bind("D", hl.dsp.exec_cmd("discord"))
bind("T", hl.dsp.exec_cmd("thunderbird"))
bind("G", hl.dsp.exec_cmd("thunar"))
bind("E", hl.dsp.exec_cmd(fileManager))
bind("R", hl.dsp.exec_cmd(menu))
bind("S", hl.dsp.exec_cmd("signal-desktop"))
bind("U", hl.dsp.exec_cmd("hyprlock"))

-- Windows
bind("C", hl.dsp.window.close())
bind("M", hl.dsp.exit())
bind("V", hl.dsp.window.float({ action = "toggle" }))
bind("P", hl.dsp.window.pseudo())
bind("I", hl.dsp.layout("togglesplit"))
bind("F", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind("SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- SUPER+` takes a region screenshot, saves to Pictures, copies to clipboard
bind(
	"grave",
	hl.dsp.exec_cmd(
		"grimblast save area - | tee ~/Pictures/screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png | wl-copy"
	)
)

-- Move focus
bind("H", hl.dsp.focus({ direction = "left" }))
bind("L", hl.dsp.focus({ direction = "right" }))
bind("K", hl.dsp.focus({ direction = "up" }))
bind("J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces / move the active window to one (0 is workspace 10)
for i = 1, 10 do
	local key = i % 10
	bind(key, hl.dsp.focus({ workspace = i }))
	bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Left drag moves windows, right drag resizes them
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys (work on the lock screen; volume/brightness repeat when held)
local held = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), held)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), held)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), held)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), held)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), held)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), held)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
