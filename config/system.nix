# Global system packages (installed for all users).
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    openjdk
    git
    gh
    alacritty
    fastfetch
  ];
}
