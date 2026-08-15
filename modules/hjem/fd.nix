{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
in {
  hjem.users.frahz = {
    packages = singleton pkgs.fd;
    xdg.config.files."fd/ignore".text = ''
      .git/
      *.bak
    '';
  };
}
