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
}
