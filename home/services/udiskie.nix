{ osConfig, ... }:
{
  services.udiskie = {
    inherit (osConfig.casa.profiles.graphical) enable;
    tray = "never";
  };
}
