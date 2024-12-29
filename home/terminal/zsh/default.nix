{
  config,
  pkgs,
  ...
}: {
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

    plugins = [
      # {
      #   name = "fzf-tab";
      #   src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      # }
    ];

    syntaxHighlighting = {
      enable = true;
    };

    shellAliases = {
      vim = "nvim";
    };

    initExtra = ''
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -hAF --color=always "$realpath"'
    '';
  };
}
