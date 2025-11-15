{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.casa.profiles.graphical.enable {
    services = {
      # a userspace virtual filesystem
      gvfs.enable = true;

      # manipulate storage devices
      udisks2.enable = true;

      # thumbnails
      tumbler.enable = true;

      dbus = {
        enable = true;
        implementation = "broker";
      };
    };
  };
}
