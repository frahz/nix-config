{ inputs, config, lib, pkgs, overlay-unstable, system, ...}:

{
    imports = [
        ../users/frahz
    ] ++ (
        import ../modules/services ++
        import ../modules/shell
    );

    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

    nixpkgs.overlays = [ overlay-unstable ];
    nixpkgs.config.allowUnfree = true;

    environment = {
        systemPackages = with pkgs; [
            inputs.agenix.packages."${system}".default
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
            unstable.tailscale
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

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = true;
        };
    };

    system.stateVersion = "23.11";
}
