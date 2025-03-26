{ pkgs, lib, ... }:

with lib;

let
  createScript = name: text: {
    name = ".local/bin/${name}";
    value = {
      executable = true;
      text = text;
    };
  };
in
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

  home.file = listToAttrs [
    (createScript "git-far" /* zsh */''
        #!/usr/bin/env zsh
        pattern="$1"
        if [ -z "$pattern" ]; then
          echo "Usage:"
          echo "git-far 's/foo/bar/g'"
          return
        fi

        # Check if git working tree is clean
        if [ ! -z "$(git status --porcelain)" ]; then
          echo "Working directory unclean!"
          return
        fi

        sed --follow-symlinks -i "$pattern" $(git ls-files)

        # Stash changes so user can preview them before applying them
        git stash --include-untracked
        git stash show -p

        read -q "REPLY?Apply changes? [y/n] " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]
        then
          git stash pop
          return
        fi

        git stash drop
    '')
    (createScript "vault-git-diff" /* zsh */''
      FILE_PATH="$1"
      GIT_REF="$2"

      if [[ -z "$GIT_REF" ]]; then
        echo "Usage:"
        echo "vault-git-diff inventory/foo/vault.yml origin/cool-git-branch"
        return
      fi

      read -s -r "ANSIBLE_VAULT_PASS?Vault password: "
      echo

      diff -u \
        <(cat "$FILE_PATH" | ansible-vault view --vault-password-file <( echo "$ANSIBLE_VAULT_PASS" ) -) \
        <(git show "$GIT_REF":"$FILE_PATH" | ansible-vault view --vault-password-file <( echo "$ANSIBLE_VAULT_PASS" ) -)
    '')
    (createScript "sgit" /* sh */''
        eval $(ssh-agent -s)
        trap "kill $SSH_AGENT_PID" EXIT
        ssh_file=""
        ls ~/.ssh/id_rsa >/dev/null 2>&1 && ssh_file="$HOME/.ssh/id_rsa"
        ls ~/.ssh/id_ed25519 >/dev/null 2>&1 && ssh_file="$HOME/.ssh/id_ed25519"
        ssh-add "$ssh_file" || kill $SSH_AGENT_PID
        git $@ || kill $SSH_AGENT_PID
        kill $SSH_AGENT_PID
    '')
    (createScript "ssha" /* sh */''
        eval $(ssh-agent -s)
        trap "kill $SSH_AGENT_PID" EXIT
        ssh -A $@
        kill $SSH_AGENT_PID
    '')
    (createScript "killwine" /* sh */''
        ps aux | egrep "wine|\.exe" | tr -s ' ' | cut -d ' ' -f 2 | xargs kill -9
    '')
  ];
}
