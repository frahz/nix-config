{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./amd.nix
    ./intel.nix
  ];

  options.casa.hardware.gpu = mkOption {
    type = types.nullOr (
      types.enum [
        "intel"
        "amd"
      ]
    );
    default = null;
    description = "The GPU manufacturer for the given system";
  };
}
