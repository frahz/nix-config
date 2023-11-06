{ config, lib, pkgs, ...}:

{
    imports = [
        ../users/frahz
    ] ++ (
        import ../modules/services
    );

    programs.zsh.enable = true;

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

    environment = {
        systemPackages = with pkgs; [
            bat
            ripgrep
            binutils
            coreutils
            docker
            fd
            git
            btop
            jq
            neovim
            tokei
            wget
            lazydocker
            tailscale
            tmux
        ];
        variables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
    };

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
        };
    };
    nixpkgs.config.allowUnfree = true;

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = true;
        };
    };

    system.stateVersion = "23.05";
}
