{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  environment = {
    defaultPackages = mkForce [ ];
  };
  programs = {
    nano.enable = false;
    less = {
      enable = mkForce false;
      lessopen = null;
    };
  };

  # this can allow us to save some storage space
  fonts.fontDir.decompressFonts = true;

  # this enables itself on systems that are graphical. but i don't need it this
  # module adds pkgs.speachd which is like 700MiB. we still will have
  # speachd-minmal in our closure due to browsers
  services.speechd.enable = false;
}
