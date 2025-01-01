{ pkgs, config, ... }:

let nixosFrontendWorkaroundConfig = /* lua */''
  -- Older Wezterm does not render anything on NixOS with default settings.
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
        -- Fonts are named slightly differently under Arch and NixOS
        '${if config.targets.genericLinux.enable then "DejaVuSansMono Nerd Font" else "DejaVuSansM Nerd Font"}',
        'DejaVu Sans Mono',
      }
      config.font_size = 8.0

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

      ${if !config.targets.genericLinux.enable then nixosFrontendWorkaroundConfig else ""}

      return config
    '';
  };
}
