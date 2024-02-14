{pkgs, ...}: {
    imports = [
        ./terminal
        ./git
        ./zsh
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
        ];
        stateVersion = "23.11";
    };
}
