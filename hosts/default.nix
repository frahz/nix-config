{
  inputs,
  lib,
  nixpkgs-unstable,
  system,
  ...
}: let
  sops-module = inputs.sops-nix.nixosModules.default;
  hm-module = inputs.home.nixosModules.home-manager;
  raulyrs-module = inputs.raulyrs.nixosModules.default;

  defaultModules = [
    sops-module
    hm-module
  ];
in {
  chibi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system nixpkgs-unstable;
      host = {
        hostName = "chibi";
      };
    };
    modules =
      [
        ./chibi
        ./configuration.nix
        raulyrs-module
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
            users.frahz = {
              imports = [../home];
            };
          };
        }
      ]
      ++ defaultModules;
  };

  inari = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system nixpkgs-unstable;
      host = {
        hostName = "inari";
      };
    };
    modules =
      [
        ./inari
        ./configuration.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
            users.frahz = {
              imports = [../home];
            };
          };
        }
      ]
      ++ defaultModules;
  };

  anmoku = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system nixpkgs-unstable;
      host = {
        hostName = "anmoku";
      };
    };
    modules =
      [
        ./anmoku
        ./configuration.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
            users.frahz = {
              imports = [../home];
            };
          };
        }
      ]
      ++ defaultModules;
  };
}
