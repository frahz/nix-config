{
  programs = {
    bash.interactiveShellInit = ''
      HISTFILE="''${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
      mkdir -p -- "''${HISTFILE%/*}"
    '';
    zsh = {
      enable = true;
      enableCompletion = false;
    };
  };
}
