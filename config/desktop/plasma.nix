# KDE Plasma desktop environment (coexist with GNOME; pick session at login).
{ config, lib, pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  # Plasma brings SDDM normally, but keep GDM as the single display manager
  # so both sessions are listed in the same login screen.
  services.displayManager.sddm.enable = false;

  # Resolve the GNOME/KDE conflict on the SSH ask-pass helper: use KDE's.
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # Exclude apps you don't want from Plasma's default set.
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   konsole
  # ];
}
