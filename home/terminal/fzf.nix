_: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = ["--preview 'bat --color=always {}'"];
    catppuccin.enable = true;
  };
}
