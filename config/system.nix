# Global system packages (installed for all users).
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Optimizar el store: dedup, auto-limpiar y GC automático (14 días).
  nix.settings = {
    auto-optimise-store = true;
    min-free = 512 * 1024 * 1024;   # 512 MiB
    max-free = 1024 * 1024 * 1024;  # 1 GiB
  };
  nix.gc.automatic = true;
  nix.gc.options = "-d 14";

  environment.systemPackages = with pkgs; [
    neovim
    openjdk
    git
    gh
    alacritty
    fastfetch
    comma
  ];
}
