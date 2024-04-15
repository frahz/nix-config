{
  inputs,
  lib,
  system,
  ...
}: let
  sops-module = inputs.sops-nix.nixosModules.default;
  hm-module = inputs.home.nixosModules.home-manager;
  hyprlandModule = inputs.hyprland.homeManagerModules.default;
  raulyrs-module = inputs.raulyrs.nixosModules.default;

  defaultModules = [
    sops-module
    hm-module
  ];
in {
  chibi = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system;
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
      inherit inputs system;
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
      inherit inputs system;
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
              imports = [
                ../home
                ../home/desktop
                hyprlandModule
              ];
            };
          };
        }
      ]
      ++ defaultModules;
  };
}
