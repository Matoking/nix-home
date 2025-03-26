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

        # Show git diff in commit message editor
        verbose = true;
      };

      # Use fast-forward pulls by default
      pull.ff = "only";

      # Enable commit autosquash by default
      rebase.autosquash = true;

      # 'master' as default branch
      init.defaultBranch = "master";

      alias.push-mr = "push -o merge_request.create -o merge_request.draft";

      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";

      # Better visual diffs
      diff = {
        algorithm = "histogram";

        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };

      # Reuse recorded resolutions
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };
  };

  home.packages = with pkgs; [
    diff-so-fancy               # Fancy diff tool
    git-absorb                  # 'git absorb' command for automatic fixups

    (openssh.override {          # Required for new fancy SSH features
      # Required for 'GSSAPIAuthentication' config param
      withKerberos = true;
    })
  ];
}
