{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = with pkgs; [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
    interactiveShellInit = /* fish */''
      # Load Tide configuration in case it doesn't exist already
      if test -z $tide_time_format
        tide configure --auto \
          --style=Rainbow \
          --prompt_colors='True color' \
          --show_time='24-hour format' \
          --rainbow_prompt_separators=Angled \
          --powerline_prompt_heads=Sharp \
          --powerline_prompt_tails=Round \
          --powerline_prompt_style='Two lines, character' \
          --prompt_connection=Disconnected \
          --powerline_right_prompt_frame=No \
          --prompt_spacing=Sparse \
          --icons='Many icons' \
          --transient=Yes
      end

      # Ctrl+F for fuzzy cd
      ${pkgs.fzf}/bin/fzf --fish | source
      bind ctrl-f fzf-cd-widget

      # Required for whatever we might have installed here (eg. poetry, pipx...)
      fish_add_path $HOME/.local/bin

      # Do not greet
      set -U fish_greeting

      # Disable virtualenv's own prompt and let Tide handle it
      set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
    '';
    shellAbbrs = {
      prettyjson = "${pkgs.python3}/bin/python -m json.tool";
      pipit = "pip install --upgrade .";
      senv = "source venv/bin/activate.fish";
      menv = "python3 -mvenv venv; source venv/bin/activate.fish";
      gad = "git add --all";
      gco = "git commit";
      gpu = "git push";
      gds = "git diff --staged";
    };
  };
}
