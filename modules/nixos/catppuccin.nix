{
  inputs,
  inputs',
  pkgs,
  ...
}:
let
  catppuccinSources = inputs'.catppuccin.packages.overrideScope (
    _final: _prev: {
      whiskers = pkgs.catppuccin-whiskers;
    }
  );
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  config = {
    catppuccin = {
      autoEnable = false;
      enable = true;
      flavor = "mocha";
      sources = catppuccinSources;
    };

    # replaces catppuccin.tty
    console.colors = [
      "1e1e2e"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "bac2de"
      "585b70"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "a6adc8"
    ];
  };
}
