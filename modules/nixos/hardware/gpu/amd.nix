{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.casa.hardware;
in
{
  config = mkIf (cfg.gpu == "amd") {
    # enable amdgpu xorg drivers
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware = {
      amdgpu = {
        # enable amdgpu kernel module
        initrd.enable = true;
        # enables AMDVLK & OpenCL support
        amdvlk = {
          enable = true;
          support32Bit.enable = true;
        };
        # disable for now, pulls in like 7 GB of stuff
        opencl.enable = false;
      };
    };
  };
}
