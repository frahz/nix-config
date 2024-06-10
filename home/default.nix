{pkgs, ...}: {
  imports = [
    ./terminal
  ];

  programs.home-manager.enable = true;

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
    ];
    stateVersion = "23.11";
  };
}
