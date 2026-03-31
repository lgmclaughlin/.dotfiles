local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- shell ---------------------------------------------------------

config.default_prog = { 'C:/Program Files/Git/bin/bash.exe', '--login', '-i' }

-- appearance ----------------------------------------------------

config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 11

config.color_scheme = 'Tokyo Night'

config.window_background_opacity = 0.5
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.audible_bell = 'Disabled'
config.scrollback_lines = 2000

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = 'RESIZE'

-- keybinds ------------------------------------------------------

config.keys = {
	-- tab management (from tmux)
	{ key = 'N', mods = 'ALT|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'M', mods = 'ALT|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
	{ key = 'L', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
	{ key = 'H', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
	{ key = 'C', mods = 'ALT|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } },
	{ key = '[', mods = 'ALT|SHIFT', action = wezterm.action.MoveTabRelative(-1) },
	{ key = ']', mods = 'ALT|SHIFT', action = wezterm.action.MoveTabRelative(1) },

	-- workspace (session) management
	{ key = ',', mods = 'ALT|SHIFT', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },

	-- pane splitting
	{ key = '\\', mods = 'ALT|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	{ key = '-', mods = 'ALT|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

	-- pane navigation (hjkl)
	{ key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
	{ key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },

	-- tab jumping by number
	{ key = '1', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(0) },
	{ key = '2', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(1) },
	{ key = '3', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(2) },
	{ key = '4', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(3) },
	{ key = '5', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(4) },
	{ key = '6', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(5) },
	{ key = '7', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(6) },
	{ key = '8', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(7) },
	{ key = '9', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(8) },
	{ key = '0', mods = 'ALT|SHIFT', action = wezterm.action.ActivateTab(9) },
}

return config
