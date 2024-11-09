self: super: {
  sugoi = self.callPackage ./sugoi.nix {};
  nemui = self.callPackage ./nemui.nix {};
  caddy-with-porkbun = self.callPackage ./caddy-with-plugins.nix {
    vendorHash = "sha256-1OJelf2Ui7Iz4SoXStfTwEtLi/fSpgfR2gqsZi7KBZE=";
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.2.1";
      }
    ];
  };
}
