{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkForce;
  inherit (lib.options) mkEnableOption;
in
{
  options.casa.profiles.oracle = {
    enable = mkEnableOption "Oracle Cloud profile";
  };

  config = lib.mkIf config.casa.profiles.oracle.enable {
    services = {
      # Unavailable - device lacks SMART capability.
      smartd.enable = mkForce false;

      qemuGuest.enable = true;

      # there is no physical hardware here to flash firmware onto
      fwupd.enable = mkForce false;

      # Unavailable - device lacks thermal sensors.
      thermald.enable = mkForce false;
    };

    # a vm has no devices that need firmware blobs loaded into them, and
    # linux-firmware is not small
    hardware.enableRedistributableFirmware = mkForce false;

    systemd.services.qemu-guest-agent.path = [ pkgs.shadow ];

    boot.initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
        "virtiofs"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };
  };
}
