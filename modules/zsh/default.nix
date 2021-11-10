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
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      source ${p10kFile};

      # Login using an ephemeral SSH agent, which is killed immediately
      # after the SSH session ends
      function ssha() {
          eval $(ssh-agent -s)
          trap "kill $SSH_AGENT_PID" EXIT
          ssh -A $@
          kill $SSH_AGENT_PID
      }

      # Kill most Wine processes
      function killwine() {
          ps aux | egrep "wine|\.exe" | tr -s ' ' | cut -d ' ' -f 2 | xargs kill -9
      }
    '';
    shellAliases = {
      prettyjson = "${pkgs.python3}/bin/python -m json.tool";
    };
  };
}
