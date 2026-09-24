{ lib, config, ... }:
let
  cfg = config.casa.networking.fail2ban;
in
{
  options.casa.networking.fail2ban.enable = lib.mkEnableOption "Fail2ban intrusion prevention";

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 7;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "100.64.0.0/10"
        "192.168.0.0/16"
      ];

      bantime-increment = {
        enable = true;
        rndtime = "12m";
        overalljails = true;
        multipliers = "4 8 16 32 64 128 256 512 1024 2048";
        maxtime = "192h";
      };

      jails.sshd.settings.mode = "aggressive";
    };
  };
}
