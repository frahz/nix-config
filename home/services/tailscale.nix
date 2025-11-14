{ osConfig, ... }:
{
  services.tailscale-systray.enable = osConfig.casa.profiles.graphical.enable;
}
