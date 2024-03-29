{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      pager = {
        # Enable fancier `git diff`
        show = "diff-so-fancy | less --tabs 1,5 -RFX";
        diff = "diff-so-fancy | less --tabs 1,5 -RFX";
      };

      "diff \"hex\"" = {
        textconv = "hexdump -v -C";
        binary = "true";
      };

      commit = {
        # Sign every commit by default
        gpgsign = true;
      };

      # Use fast-forward pulls by default
      pull.ff = "only";

      # Enable commit autosquash by default
      rebase.autosquash = true;

      # 'master' as default branch
      init.defaultBranch = "master";
    };
  };

  home.packages = with pkgs; [
    diff-so-fancy               # Fancy diff tool
    openssh                     # Required for new fancy SSH features
  ];
}
