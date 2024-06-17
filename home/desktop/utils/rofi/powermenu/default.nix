{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "powermenu" ''
      # CMDs
      uptime="$(${pkgs.procps}/bin/uptime -p | sed -e 's/up //g')"
      host=$(hostname)

      # Options
      shutdown=' Shutdown'
      reboot=' Reboot'
      lock=' Lock'
      suspend=' Suspend'
      logout='󰍃 Logout'
      yes='Yes'
      no='No'

      # Rofi CMD
      rofi_cmd() {
          ${pkgs.rofi-wayland}/bin/rofi -dmenu \
              -p "$host" \
              -mesg "Uptime: $uptime" \
              -no-config \
              -theme ~/.config/rofi/powermenu.rasi
      }

      # Confirmation CMD
      confirm_cmd() {
          ${pkgs.rofi-wayland}/bin/rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
              -theme-str 'mainbox {children: [ "message", "listview" ];}' \
              -theme-str 'listview {columns: 2; lines: 1;}' \
              -theme-str 'element-text {horizontal-align: 0.5;}' \
              -theme-str 'textbox {horizontal-align: 0.5;}' \
              -dmenu \
              -p 'Confirmation' \
              -mesg 'Are you Sure?' \
              -no-config \
              -theme ~/.config/rofi/powermenu.rasi
      }

      # Ask for confirmation
      confirm_exit() {
          echo -e "$yes\n$no" | confirm_cmd
      }

      # Pass variables to rofi dmenu
      run_rofi() {
          echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
      }

      # Execute Command
      run_cmd() {
          selected="$(confirm_exit)"
          if [[ "$selected" == "$yes" ]]; then
              if [[ $1 == '--shutdown' ]]; then
                  systemctl poweroff
              elif [[ $1 == '--reboot' ]]; then
                  systemctl reboot
              elif [[ $1 == '--suspend' ]]; then
                  mpc -q pause
                  amixer set Master mute
                  systemctl suspend
              elif [[ $1 == '--logout' ]]; then
                  hyprctl dispatch exit
              fi
          else
              exit 0
          fi
      }

      # Actions
      case "$(run_rofi)" in
          $shutdown)
              run_cmd --shutdown
              ;;
          $reboot)
              run_cmd --reboot
              ;;
          $lock)
              hyprlock
              ;;
          $suspend)
              run_cmd --suspend
              ;;
          $logout)
              run_cmd --logout
              ;;
      esac
    '')
  ];
  xdg.configFile."rofi/powermenu.rasi" = {
    source = ./powermenu.rasi;
  };
}
