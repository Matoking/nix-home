{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yamllint                          # YAML linter
    python3Packages.pylint            # Python linter
    python3Packages.isort             # Python import sorting tool
    shellcheck                        # Shell linter
    httpie                            # Curl-like tool for humans
    htop                              # Process viewer
    moar                              # moar is less (but more)
    ripgrep                           # Very fast grep-like tool
    statix                            # Nix linter
    fzf                               # Fuzzy search
  ];

  # Fast Python linter
  programs.ruff = {
    enable = true;
    settings = {
      lint.select = [
        "E"   # pycodestyle
        "F"   # pyflakes
        "UP"  # pyupgrade
        "B"   # flake8-bugbear
        "SIM" # flake8-simplify
        "PL"  # pylint
      ];
    };
  };
}
