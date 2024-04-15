{config, ...}: {
  xdg.configFile."omz/themes/frahz.zsh-theme" = {
    source = ./frahz.zsh-theme;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "tmux"];
      custom = "${config.xdg.configHome}/omz";
      theme = "frahz";
    };

    syntaxHighlighting = {
      enable = true;
    };

    shellAliases = {
      vim = "nvim";
    };
  };
}
