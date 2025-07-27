{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./amd.nix
    ./intel.nix
  ];

  options.casa.hardware.cpu = mkOption {
    type = types.nullOr (
      types.enum [
        "intel"
        "vm-intel"
        "amd"
        "vm-amd"
      ]
    );
    default = null;
    description = "The CPU manufacturer for the given system";
  };
}
