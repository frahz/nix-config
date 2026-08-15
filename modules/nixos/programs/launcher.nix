{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.casa.profiles.graphical;
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    fuzzel=${lib.getExe pkgs.fuzzel}
    hyprlock=${lib.getExe pkgs.hyprlock}
    uptime="$(${pkgs.procps}/bin/uptime -p | sed -e 's/up //g')"

    lock="  Lock"
    logout="󰗽  Logout"
    suspend="  Suspend"
    reboot="  Reboot"
    shutdown="  Shutdown"
    yes="Yes"
    no="No"

    chosen=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | $fuzzel --dmenu --lines 5 --prompt "  " --placeholder "$uptime")

    confirm_exit() {
      echo -e "$yes\n$no" | $fuzzel --dmenu --lines 2 --prompt "Are you sure? "
    }

    run_cmd() {
      selected="$(confirm_exit)"
      if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
          systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
          systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
          systemctl suspend
        elif [[ $1 == '--logout' ]]; then
          hyprctl dispatch exit
        fi
      else
        exit 0
      fi
    }

    case "$chosen" in
      "$lock") $hyprlock ;;
      "$logout") run_cmd --logout ;;
      "$suspend") run_cmd --suspend ;;
      "$reboot") run_cmd --reboot ;;
      "$shutdown") run_cmd --shutdown ;;
    esac
  '';
in
{
  config = lib.mkIf cfg.enable {
    hjem.users.frahz = {
      packages = builtins.attrValues {
        inherit (pkgs) bemoji fuzzel;
        inherit powermenu;
      };
      xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = (pkgs.formats.ini { }).generate "fuzzel.ini";
        value = {
          main = {
            font = "Berkeley Mono:size=12";
            icon-theme = "Papirus";
            anchor = "top";
            y-margin = 360;
            lines = 5;
            width = 40;
            tabs = 4;
            horizontal-pad = 20;
            line-height = 30;
          };
          colors = {
            background = "000000ff";
            text = "f2f0e5ff";
            prompt = "f5bde6ff";
            input = "f2f0e5ff";
            match = "f5bde6ff";
            selection = "130f12ff";
            selection-match = "f5bde6ff";
            selection-text = "f2f0e5ff";
            border = "1b1b1dff";
          };
          border = {
            width = 2;
            radius = 5;
          };
        };
      };
    };
  };
}
