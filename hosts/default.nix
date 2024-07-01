{
  inputs,
  lib,
  system,
  ...
}: let
  catppuccin-hm = inputs.catppuccin.homeManagerModules.catppuccin;

  hm-module = inputs.home.nixosModules.home-manager;
  catppuccin-module = inputs.catppuccin.nixosModules.catppuccin;
  sops-module = inputs.sops-nix.nixosModules.default;
  raulyrs-module = inputs.raulyrs.nixosModules.default;

  defaultModules = [
    catppuccin-module
    hm-module
    sops-module
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
              imports = [../home catppuccin-hm];
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
              imports = [../home catppuccin-hm];
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
                catppuccin-hm
              ];
            };
          };
        }
      ]
      ++ defaultModules;
  };
}
