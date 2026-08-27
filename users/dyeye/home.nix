{ pkgs, ... }:
{
  home.username = "dyeye";
  home.homeDirectory = "/home/dyeye";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    vscode
    google-chrome
    opencode

    # Gaming
    itch
    heroic
    protonplus
  ];

  programs.home-manager.enable = true;
}
