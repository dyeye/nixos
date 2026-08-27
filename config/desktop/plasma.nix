# KDE Plasma desktop environment (default session).
{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Exclude apps you don't want from Plasma's default set.
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   konsole
  # ];
}
