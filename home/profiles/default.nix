{
  inputs,
  self,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "frahz@desktop" = [
      ../.
      ./anmoku.nix
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
    default = [
      ../.
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake.homeConfigurations = {
    "frahz_desktop" = homeManagerConfiguration {
      modules = homeImports."frahz@desktop";
      inherit pkgs extraSpecialArgs;
    };
    default = homeManagerConfiguration {
      modules = homeImports.default;
      inherit pkgs extraSpecialArgs;
    };
  };
}
