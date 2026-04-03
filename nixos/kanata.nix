{ config, pkgs, ... }:

{
  boot.kernelModules = [ "uinput" ];
  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
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
}
