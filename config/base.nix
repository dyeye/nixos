# Base system configuration. Shared settings that don't depend on a desktop.
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "dyeyes";

  # Enable networking.
  networking.networkmanager.enable = true;

  # Time zone.
  time.timeZone = "America/Mexico_City";

  # Internationalisation.
  i18n.defaultLocale = "en_US.UTF-8";

  # Keymap (X11).
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "es";
    variant = "nodeadkeys";
  };

  # Console keymap.
  console.keyMap = "es";

  # Printing.
  services.printing.enable = true;

  # Sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    # media-session.enable = true;
  };

  # User account.
  users.users."dyeye" = {
    isNormalUser = true;
    description = "Maximo Gomez Cruz";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
