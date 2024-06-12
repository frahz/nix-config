{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    catppuccin.enable = true;
    config = {
      osc = "no";
      border = "no";
    };
    scripts = with pkgs.mpvScripts; [
      modernx
    ];
  };
}
