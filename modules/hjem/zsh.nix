{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = config.hjem.users.frahz;
in
{
  hjem.users.frahz = {
    packages = builtins.attrValues {
      inherit (pkgs) nix-zsh-completions oh-my-zsh zsh;
    };
    extraDependencies = builtins.attrValues {
      inherit (pkgs) zsh-autosuggestions zsh-syntax-highlighting;
    };

    files.".zshenv".text = ''
      export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
      source "$ZDOTDIR/.zshenv"
    '';
    xdg.config.files = {
      "zsh/.zshenv".text = ''
        source ${user.environment.loadEnv}

        export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
        export ZSH_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
      '';
      "zsh/.zprofile".text = ''
        # Login-shell initialization is intentionally centralized in .zshenv.
      '';
      "zsh/.zshrc".text = ''
        fpath+=(${pkgs.nix-zsh-completions}/share/zsh/site-functions)
        autoload -U compinit && compinit

        export ZSH_CUSTOM="''${XDG_CONFIG_HOME:-$HOME/.config}/omz"
        ZSH_THEME="frahz"
        plugins=(git tmux)
        source "$ZSH/oh-my-zsh.sh"

        HISTSIZE="100000"
        SAVEHIST="100000"
        HISTFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh_history"
        mkdir -p -- "''${HISTFILE:h}"

        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source <(${lib.getExe pkgs.fzf} --zsh)
        eval "$(${lib.getExe pkgs.direnv} hook zsh)"

        if [[ -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
          source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
        fi

        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        alias fd='fd --hidden'
        alias vim='nvim'
      '';
      "omz/themes/frahz.zsh-theme".source = ./frahz.zsh-theme;
    };
  };
}
