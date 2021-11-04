{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yamllint                          # YAML linter
    python38Packages.flake8           # Python - PEP 8 linter
    python38Packages.pylint           # Python linter
    python38Packages.isort            # Python import sorting tool
    shellcheck                        # Shell linter
    httpie                            # Curl-like tool for humans
  ];
}
