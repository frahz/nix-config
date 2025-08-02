{
  programs.home-manager.enable = true;

  imports = [
    ./cli
    ./gui
    ./packages.nix
    ./services
    ./system
    ./themes
    ./tui
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
    };
    stateVersion = "23.11";
  };
}
