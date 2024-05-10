self: super: {
  sugoi = self.callPackage ./sugoi.nix {};
  nemui = self.callPackage ./nemui.nix {};
  caddy-with-porkbun = self.callPackage ./caddy-with-plugins.nix {
    vendorHash = "sha256-tR9DQYmI7dGvj0W0Dsze0/BaLjG84hecm0TPiCVSY2Y=";
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.1.4";
      }
    ];
  };
}
