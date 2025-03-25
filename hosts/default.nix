{
  self,
  inputs,
  homeImports,
  ...
}: let
  hm-module = inputs.home.nixosModules.home-manager;
  catppuccin-module = inputs.catppuccin.nixosModules.catppuccin;
  sops-module = inputs.sops-nix.nixosModules.default;
  raulyrs-module = inputs.raulyrs.nixosModules.default;
  lix-module = inputs.lix-module.nixosModules.default;

  defaultModules = [
    catppuccin-module
    hm-module
    sops-module
    lix-module
  ];
in {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;

    specialArgs = {inherit inputs self;};
  in {
    chibi = nixosSystem {
      inherit specialArgs;
      modules =
        [
          ./chibi
          ./configuration.nix
          raulyrs-module
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
              users.frahz = {
                imports = homeImports.default;
              };
            };
          }
        ]
        ++ defaultModules;
    };

    inari = nixosSystem {
      inherit specialArgs;
      modules =
        [
          ./inari
          ./configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
              users.frahz = {
                imports = homeImports.default;
              };
            };
          }
        ]
        ++ defaultModules;
    };

    anmoku = nixosSystem {
      inherit specialArgs;
      modules =
        [
          ./anmoku
          ./configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
              users.frahz = {
                imports = homeImports."frahz@desktop";
              };
            };
          }
        ]
        ++ defaultModules;
    };
  };
}
