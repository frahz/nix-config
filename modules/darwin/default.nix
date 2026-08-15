{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.darwinModules.catppuccin
    inputs.hjem.darwinModules.default

    ../base
  ];

  catppuccin = {
    autoEnable = false;
    enable = true;
    flavor = "mocha";
  };

  nix = {
    # Adjusts interval to match "03:15" interval used on NixOS (daily, as opposed to the default weekly on darwin).
    gc.interval = {
      Hour = 3;
      Minute = 15;
    };
  };

  system.primaryUser = "frahz";
  system.stateVersion = 6;
}
