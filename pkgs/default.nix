self: super: {
    sugoi = self.callPackage ./sugoi.nix {};
    nemui = self.callPackage ./nemui.nix {};
}
