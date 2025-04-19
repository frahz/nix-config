self: super: {
  nemui = self.callPackage ./nemui.nix {};
  hyprland-preview-share-picker = self.callPackage ./hyprland-preview-share-picker.nix {};
}
