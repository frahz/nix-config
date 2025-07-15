{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "powermenu" ''
      # Commands
      fuzzel="${lib.getExe config.programs.fuzzel.package}"
      hyprlock="${lib.getExe config.programs.hyprlock.package}"
      uptime="$(${pkgs.procps}/bin/uptime -p | sed -e 's/up //g')"

      # Options
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
            # mpc -q pause
            # amixer set Master mute
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
        "$shutdown") run_cmd --shutdown;;
      esac
    '')
  ];
}
