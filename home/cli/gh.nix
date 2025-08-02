{ config, ... }:
{
  programs.gh = {
    inherit (config.programs.git) enable;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
