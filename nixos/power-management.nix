{ config, lib, pkgs, ... }:

{
  # Swap
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;  # 32GB
    }
  ];

  # Hibernate resume device - update these after first boot with swap active:
  #   UUID:   df /swapfile --output=source | tail -1 | xargs blkid -s UUID -o value
  #   offset: sudo filefrag -v /swapfile | awk 'NR==4{print $4}' | tr -d '.'
  boot.resumeDevice = "/dev/disk/by-uuid/c024248d-9480-4409-955e-43b462b676fd";
  boot.kernelParams = [ "resume_offset=142135296" ];

  # Hybrid sleep: suspends to RAM, but hibernates after delay if still sleeping
  systemd.sleep.extraConfig = ''
    HibernateMode=platform shutdown
    HibernateDelaySec=30m
  '';

  # Lid/power button behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
    HandlePowerKey = "suspend-then-hibernate";
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "20min";
  };
}
