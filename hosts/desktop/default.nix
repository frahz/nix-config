{
  casa = {
    profiles = {
      development.enable = true;
    };
    hardware = {
      cpu = null;
      gpu = null;
      capabilities = {
        bluetooth = true;
      };
      moondrop.enable = true;
    };
    system = {
      boot = {
        loader = "none";
        silentBoot = true;
      };
      bluetooth.enable = false;
    };
    networking = {
      tailscale.enable = false;
    };
  };
}
