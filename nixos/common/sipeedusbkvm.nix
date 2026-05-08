{ config, pkgs, ... }:
{
  services.brltty.enable = false;
  users.users.rileytuttle = {
    extraGroups = [ "dialout" ];
  };
  environment.systemPackages = with pkgs; [
    google-chrome
  ];
}
