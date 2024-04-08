{ pkgs, ... }:

{
  home.file.".config/kitty/kitty.conf" = {
    text = ''
      # Use Deja Vu Sans Mono patched with Nerd Fonts
      font_family      DejaVuSansMono Nerd Font Book
      font_size 8.0

      # Use 'xterm-256color' TERM. Seems to have the best compatibility.
      term xterm-256color

      # Cache more lines
      scrollback_lines 200000

      # Make things a tiny bit faster
      repaint_delay 5

      # Use 'splits' layout
      enabled_layouts splits

      map ctrl+shift+e launch --cwd=current --location=vsplit
      map ctrl+shift+o launch --cwd=current --location=hsplit

      map ctrl+shift+t launch --cwd=current --type=tab

      map alt+left neighboring_window left
      map alt+right neighboring_window right
      map alt+up neighboring_window up
      map alt+down neighboring_window down

      # Use Tango color scheme
      background            #000000
      foreground            #ffffff
      cursor                #ffffff
      selection_background  #b4d5ff
      color0                #000000
      color8                #545753
      color1                #cc0000
      color9                #ef2828
      color2                #4e9a05
      color10               #8ae234
      color3                #c4a000
      color11               #fce94e
      color4                #3464a4
      color12               #719ecf
      color5                #74507a
      color13               #ad7ea7
      color6                #05989a
      color14               #34e2e2
      color7                #d3d7cf
      color15               #ededec
      selection_foreground #000000

      # Fade the text in inactive windows slightly
      inactive_text_alpha 0.5

      # Use a different tab style
      tab_bar_style slant
    '';
  };
}
