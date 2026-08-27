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

  # nix-index-database: `comma` para ejecutar binarios sin instalarlos.
  programs.nix-index-database.comma.enable = true;

  programs.home-manager.enable = true;
}
