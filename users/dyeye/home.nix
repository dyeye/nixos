{ pkgs, ... }:
{
  home.username = "dyeye";
  home.homeDirectory = "/home/dyeye";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    vscode
    google-chrome
    opencode
  ];

  programs.home-manager.enable = true;
}
