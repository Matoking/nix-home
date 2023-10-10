{ config, pkgs, ... }:

let p10kFile = ./p10k.zsh;
in
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
    };
    initExtra = ''
      # Ensure UTF-8 locale is used if available. Powerlevel10k requires
      # UTF-8, otherwise it will crash and burn and leave the shell
      # unusable.
      if ! locale | grep -i "\.utf" &> /dev/null || locale -a | grep "en_US.utf8" &> /dev/null; then
        export LANG=en_US.UTF-8
      fi

      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.

      # Only load Powerlevel10k if we have a sane locale.
      # This ensures we have a working shell even if this system does not have
      # UTF-8 support for some reason.
      if locale | grep -i "\.utf" &> /dev/null; then
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        source ${p10kFile};
      fi

      # Login using an ephemeral SSH agent, which is killed immediately
      # after the SSH session ends
      function ssha() {
          eval $(ssh-agent -s)
          trap "kill $SSH_AGENT_PID" EXIT
          ssh -A $@
          kill $SSH_AGENT_PID
      }

      # Run a `git` command with an ephemeral SSH agent.
      # This helps avoid multiple passphrase prompts if we're doing something
      # that would mean signing tons of commits (eg. rebasing).
      function sgit() {
        eval $(ssh-agent -s)
        trap "kill $SSH_AGENT_PID" EXIT
        ssh_file=""
        ls ~/.ssh/id_rsa >/dev/null 2>&1 && ssh_file="$HOME/.ssh/id_rsa"
        ls ~/.ssh/id_ed25519 >/dev/null 2>&1 && ssh_file="$HOME/.ssh/id_ed25519"
        ssh-add "$ssh_file" || kill $SSH_AGENT_PID
        git $@ || kill $SSH_AGENT_PID
        kill $SSH_AGENT_PID
      }

      # Kill most Wine processes
      function killwine() {
          ps aux | egrep "wine|\.exe" | tr -s ' ' | cut -d ' ' -f 2 | xargs kill -9
      }
    '';
    shellAliases = {
      prettyjson = "${pkgs.python3}/bin/python -m json.tool";
      pipit = "pip install --upgrade .";
    };
  };
}
