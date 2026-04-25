{ osConfig, ... }:
{
  # services.blueman-applet.enable = false;
  services.blueman-applet.enable = osConfig.casa.profiles.graphical.enable;
}
