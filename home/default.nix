{pkgs, ...}: {
    imports = [
        ./zsh
        ./git
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
