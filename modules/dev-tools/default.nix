{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yamllint                          # YAML linter
    python3Packages.pylint            # Python linter
    python3Packages.isort             # Python import sorting tool
    ruff                              # Fast Python linter
    shellcheck                        # Shell linter
    httpie                            # Curl-like tool for humans
    ansible-lint                      # Ansible linting tool
    htop                              # Process viewer
    moar                              # moar is less (but more)
  ];
}
