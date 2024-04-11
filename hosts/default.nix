{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  defaultModules,
  system,
  ...
}: let
  overlay-unstable = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  overlay-local = import ../pkgs;

  inherit (nixpkgs) lib;
in {
  chibi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system overlay-unstable overlay-local;
      host = {
        hostName = "chibi";
      };
    };
    modules =
      [
        ./chibi
        ./configuration.nix
      ]
      ++ defaultModules;
  };

  inari = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system overlay-unstable overlay-local;
      host = {
        hostName = "inari";
      };
    };
    modules =
      [
        ./inari
        ./configuration.nix
      ]
      ++ defaultModules;
  };

  anmoku = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system overlay-unstable overlay-local;
      host = {
        hostName = "anmoku";
      };
    };
    modules =
      [
        ./anmoku
        ./configuration.nix
      ]
      ++ defaultModules;
  };
}
