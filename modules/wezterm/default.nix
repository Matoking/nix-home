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

      config.scrollback_lines = 50000

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
        {
          key = 'H',
          mods = 'CTRL|SHIFT',
          action = act.EmitEvent 'trigger-less-with-scrollback',
        },
      }

      -- Copied from https://github.com/wezterm/wezterm/issues/119#issuecomment-1206593847
      config.mouse_bindings = {
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
          event={Up={streak=1, button="Left"}},
          mods="NONE",
          action=act.CompleteSelection("PrimarySelection"),
        },

        -- and make CTRL-Click open hyperlinks
        {
          event={Up={streak=1, button="Left"}},
          mods="CTRL",
          action=act.OpenLinkAtMouseCursor,
        },

        -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
        {
          event = { Down = { streak = 1, button = 'Left' } },
          mods = 'CTRL',
          action = act.Nop,
        }
      },

      wezterm.on('trigger-less-with-scrollback', function(window, pane)
        -- Retrieve the current pane's text
        local text = pane:get_lines_as_escapes(pane:get_dimensions().scrollback_rows)

        -- Create a temporary file to pass to the pager
        local name = os.tmpname()
        local f = io.open(name, 'w+')
        f:write(text)
        f:flush()
        f:close()

        -- Open a new window running less and tell it to open the file
        window:perform_action(
          act.SpawnCommandInNewTab {
            args = { 'less', '-fr', name },
            domain = 'DefaultDomain',
          },
          pane
        )

        -- Wait "enough" time for less to read the file before we remove it.
        -- The window creation and process spawn are asynchronous wrt. running
        -- this script and are not awaitable, so we just pick a number.
        --
        -- Note: We don't strictly need to remove this file, but it is nice
        -- to avoid cluttering up the temporary directory.
        wezterm.sleep_ms(1000)
        os.remove(name)
      end)

      ${if !config.targets.genericLinux.enable then waylandWorkaroundConfig else ""}

      return config
    '';
  };
}
