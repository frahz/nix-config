{ inputs, pkgs, ... }:
{
  imports = [
    ./terminal
    inputs.catppuccin.homeModules.catppuccin
  ];

  programs.home-manager.enable = true;

  catppuccin = {
    accent = "pink";
    flavor = "mocha";
  };

  home = {
    packages = with pkgs; [
      fd
      ripgrep
      yt-dlp
      unzip
      unrar
      gh
      dig
      killall
      jq
      tokei
      wget
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
    };
    stateVersion = "23.11";
  };
}
