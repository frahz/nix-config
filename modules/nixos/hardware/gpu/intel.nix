{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf attrValues;
  cfg = config.casa.hardware;
in
{
  config = mkIf (cfg.gpu == "intel") {
    # i915 kernel module
    # boot.initrd.kernelModules = [ "i915" ];
    # we enable modesetting since this is recommended for intel gpus
    # services.xserver.videoDrivers = [ "modesetting" ];

    # OpenCL support and VAAPI
    hardware.graphics = {
      extraPackages = attrValues {
        inherit (pkgs)
          libva-vdpau-driver
          intel-media-driver
          libvdpau-va-gl
          ;

        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };
    };

    environment.systemPackages = [ pkgs.intel-gpu-tools ];

  };
}
