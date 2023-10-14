{ config, pkgs, lib, ...}:

let
    hostname = "chibi";
    user = "frahz";
    password = "testing";

    timeZone = "America/Los_Angeles";
    defaultLocale = "en_US.UTF-8";

in {

    networking.hostName = hostname;
    networking.

    environment.systemPackages = with pkgs; [
        neovim
        btop
        lazydocker
    ];

    services.openssh.enable = true;

    time.timeZone = timeZone;
    i18n = {
        defaultLocale = defaultLocale;
        extraLocaleSettings = {
            LC_ADDRESS = defaultLocale;
            LC_IDENTIFICATION = defaultLocale;
            LC_MEASUREMENT = defaultLocale;
            LC_MONETARY = defaultLocale;
            LC_NAME = defaultLocale;
            LC_NUMERIC = defaultLocale;
            LC_PAPER = defaultLocale;
            LC_TELEPHONE = defaultLocale;
            LC_TIME = defaultLocale;
        };
    };

    users = {
        mutableUsers = false;
        users."${user}" = {
            isNormalUser = true;
            password = password;
            extraGroups = [ "wheel" ];
        };
    };

    system.stateVersion = "23.11";
}
