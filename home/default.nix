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
    username = "frahz";
    homeDirectory = "/home/frahz";
    packages = with pkgs; [
      fd
      ripgrep
      yt-dlp
      unzip
      unrar
      gh
      dig
    ];
    stateVersion = "23.11";
  };
}
