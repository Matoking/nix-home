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
    };
  };

  home.packages = with pkgs; [
    diff-so-fancy               # Fancy diff tool
  ];
}
