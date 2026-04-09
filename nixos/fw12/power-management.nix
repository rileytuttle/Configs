{ config, lib, pkgs, ... }:

{
  boot.resumeDevice = "/dev/disk/by-uuid/b4b67747-cbc6-45c9-b8ce-1e4feb0d4d85";

  # Hybrid sleep: suspends to RAM, but hibernates after delay if still sleeping
  systemd.sleep.extraConfig = ''
    HibernateMode=platform shutdown
    HibernateDelaySec=10m
  '';

  # Lid/power button behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
    HandlePowerKey = "suspend-then-hibernate";
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "15min";
  };
}
