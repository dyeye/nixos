# Cosas por hacer después

## Escritorios
1. KDE Plasma (Funciona) [x]
2. GNOME (Eliminado) [x]
3. Hyprland (+ caelestia-shell, opcional) [ ]

## Fase 1 — Higiene del flake
- [x] Perfecto: flake + home-manager separados
- [ ] nix optimo: auto-optimise-store, GC automatico (14d), min/max-free
- [ ] nix-index-database (comma y nix-index) como input
- [ ] Boot minimo: configurationLimit
- [ ] zram swap (15GB RAM)

## Fase 2 — Modularidad (patron SamLukeYes)
- [ ] modules/ con options.nix (flags booleanos)
- [ ] modules/apps (gaming, editor, browser), modules/hardware
- [ ] modules/optional/ (printing, virtualization, dev)
- [ ] machines/dyeyes (config pura de imports + flags)
- [ ] futuro: segunda maquina en machines/

## Fase 3 — Home Manager a tope
- [ ] programs.alacritty, fastfetch, git, gh
- [ ] zsh / bash + starship
- [ ] xdg.configFile: zed, neovim init.lua al repo
- [ ] fuentes Nerd + qt.platformTheme
- [ ] home.activation.fixSteamIcons (wiki)

## Fase 4 — Avanzado
- [ ] ./pkgs + overlays (empaquetar apps propias)
- [ ] patches de nixpkgs (patron del repo ref)
- [ ] impermanence / preservation (root-on-tmpfs): riesgo alto
- [ ] secretos: sops-nix o agenix
- [ ] stylix theming
- [ ] iso.nix + GitHub Actions (nix flake check en CI)

## Apps preinstaladas en base nix
- alacritty como terminal por defecto (100%)
- git
- gh
- node (pendiente)

## Fixes pendientes
- Chrome / itch abren mil instancias y no dejan iniciar sesion por OAuth