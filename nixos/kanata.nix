{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libinput
  ];

  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", \
      MODE="0660", \
      GROUP="uinput", \
      OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = {};

  systemd.services.kanata-keyboard.serviceConfig = {
    SupplementaryGroups = [ "input" "uinput" ];
  };

  environment.etc."kanata/kanata.kbd" = {
    source = /home/rileytuttle/Configs/dotfiles/kanataconfig.kbd;
  };

  services.kanata = {
    enable = true;
    keyboards = {
      keyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
        configFile = "/etc/kanata/kanata.kbd";
      };
    };
  };

  environment.etc."kanata-tablet-watcher.sh" = {
    mode = "0755";
    text = ''
      #!${pkgs.bash}/bin/bash
      WAS_RUNNING_FLAG="/run/kanata-was-running"

      ${pkgs.libinput}/bin/libinput debug-events 2>/dev/null | while read -r line; do
        if echo "$line" | grep -q "switch tablet-mode state 1"; then
          if systemctl is-active --quiet kanata.service; then
            sudo touch "$WAS_RUNNING_FLAG"
            sudo systemctl stop kanata.service
          fi

        elif echo "$line" | grep -q "switch tablet-mode state 0"; then
          if [ -f "$WAS_RUNNING_FLAG" ]; then
            sudo rm -f "$WAS_RUNNING_FLAG"
            sudo systemctl start kanata.service
          fi
        fi
      done
    '';
  };

  systemd.services.kanata-tablet-watcher = {
    description = "Stop/start kanata based on tablet mode switch";
    wantedBy = [ "multi-user.target" ];
    after = [ "kanata.service" "systemd-udevd.service" ];

    serviceConfig = {
      ExecStart = "/etc/kanata-tablet-watcher.sh";
      Restart = "always";
      RestartSec = "2s";
      User = "root";
    };
  };

}
