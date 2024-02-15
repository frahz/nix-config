{config, ...}: {
  networking.firewall = {
    allowedTCPPorts = [3030];
    allowedUDPPorts = [3030];
  };

  virtualisation.oci-containers.containers.excalidraw = {
    autoStart = true;
    image = "excalidraw/excalidraw:latest";
    environment = {
      TZ = "America/Los_Angeles";
    };
    ports = [
      "3030:80"
    ];
  };
}
