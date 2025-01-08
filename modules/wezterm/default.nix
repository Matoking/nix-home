{ pkgs, config, ... }:

let waylandWorkaroundConfig = /* lua */''
  -- Older Wezterm does not render anything on most distros (at least NixOS and
  -- Wayland) with default settings.
  -- See github.com/NixOS/nixpkgs#336069
  config.front_end = 'WebGpu'
  config.enable_wayland = false
'';
  in
{
  home.file.".config/wezterm/wezterm.lua" = {
    text = /* lua */''
      local wezterm = require 'wezterm'
      local config = {}

      local act = wezterm.action

      -- Appearance
      config.color_scheme = 'iTerm2 Tango Dark'
      config.font = wezterm.font_with_fallback {
        -- Fonts are named slightly differently under Arch and NixOS.
        -- We ask for Nerd Font specifically because the built-in font in
        -- Wezterm is missing some symbols.
        {
          family = '${if config.targets.genericLinux.enable then "DejaVuSansMono Nerd Font" else "DejaVuSansM Nerd Font"}',
        },
      }
      -- Adjust font to be slightly thinner. This could result in artifacts
      -- so remove 'cell_width' if problems arise.
      config.cell_width = 0.8
      config.font_size = 8.0

      config.window_padding = {
        left = 0,
        right = 0,
        top = 2,
        bottom = 2
      }

      config.max_fps = 180

      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false

      -- Key bindings
      config.keys = {
        {
          key = 'e',
          mods = 'CTRL|SHIFT',
          action = act.SplitHorizontal
        },
        {
          key = 'o',
          mods = 'CTRL|SHIFT',
          action = act.SplitVertical
        },
        {
          key = 'LeftArrow',
          mods = 'ALT',
          action = act.ActivatePaneDirection 'Left',
        },
        {
          key = 'RightArrow',
          mods = 'ALT',
          action = act.ActivatePaneDirection 'Right',
        },
        {
          key = 'UpArrow',
          mods = 'ALT',
          action = act.ActivatePaneDirection 'Up',
        },
        {
          key = 'DownArrow',
          mods = 'ALT',
          action = act.ActivatePaneDirection 'Down',
        },
        {
          key = 'LeftArrow',
          mods = 'CTRL|SHIFT',
          action = act.ActivateTabRelative(-1),
        },
        {
          key = 'RightArrow',
          mods = 'CTRL|SHIFT',
          action = act.ActivateTabRelative(1),
        },
      }

      ${if !config.targets.genericLinux.enable then waylandWorkaroundConfig else ""}

      return config
    '';
  };
}
