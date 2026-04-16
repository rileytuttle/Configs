# thunderbolt-network-laptop.nix
# Add to your imports in configuration.nix:
#   imports = [ ./thunderbolt-network-laptop.nix ];

{ config, lib, pkgs, ... }:

{
  # Thunderbolt device authorization daemon
  services.hardware.bolt.enable = true;
}
