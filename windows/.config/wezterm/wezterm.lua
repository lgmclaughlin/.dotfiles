local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- shell ---------------------------------------------------------

config.default_prog = { wezterm.home_dir .. "/AppData/Local/Programs/Git/bin/bash.exe", "--login", "-i" }

-- appearance ----------------------------------------------------

config.font = wezterm.font("NotoSansM NF")
config.font_size = 12

config.color_scheme = "Tokyo Night"
config.colors = {
	background = "#181829",
}

config.window_background_opacity = 0.7
config.win32_system_backdrop = "Disable"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.audible_bell = "Disabled"
config.scrollback_lines = 2000

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 200

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

-- keybinds ------------------------------------------------------

config.keys = {
	-- tab management
	{ key = "N", mods = "ALT|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "M", mods = "ALT|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "L", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "H", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "C", mods = "ALT|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "[", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "]", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(1) },

	-- workspace (session) management
	{ key = ",", mods = "ALT|SHIFT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	-- pane splitting
	{ key = "\\", mods = "ALT|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- pane navigation (hjkl)
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
}

return config
