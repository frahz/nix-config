{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    autoEnable = false;
    enable = true;
    accent = "pink";
    flavor = "mocha";
  };

}
