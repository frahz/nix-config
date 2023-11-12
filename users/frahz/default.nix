{ lib, pkgs, ...}:
let
    username = "frahz";
in
{
    users.users.${username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "video" "lp" "docker" ];
        shell = pkgs.zsh;
        description = "frahz";
        uid = 1000;
    };
}
