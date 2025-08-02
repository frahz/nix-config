{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    accent = "pink";
    flavor = "mocha";
  };

}
