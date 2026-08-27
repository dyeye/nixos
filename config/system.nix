# Global system packages (installed for all users).
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    openjdk
    git
    gh
    alacritty
  ];
}
