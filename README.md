# nixos

Configuración de NixOS de **dyeye** (flake + home-manager).

## Estructura

```
/etc/nixos/
├── flake.nix                     # inputs y definición del sistema
├── flake.lock                    # versiones inmutables de los inputs
├── config/
│   ├── hardware-configuration.nix  # auto-generado, no editar
│   ├── base.nix                    # común: kernel, red, audio, usuario, keymap
│   ├── system.nix                  # paquetes globales + steam + gamemode
│   └── desktop/
│       └── plasma.nix              # KDE Plasma + SDDM
└── users/
    └── dyeye/
        └── home.nix                # home-manager (paquetes y dotfiles del usuario)
```

## Reconstrucción

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#dyeyes
```

## Escritorio

- **KDE Plasma 6** con **SDDM** como display manager.
- Para quitar aplicaciones del set por defecto, usa `environment.plasma6.excludePackages` en `config/desktop/plasma.nix`.

## Gaming

- Steam se instala vía `programs.steam.enable` (más `gamemode`).
- Lanzadores (itch, Heroic, ProtonPlus) en `users/dyeye/home.nix`.

## Notas

- El repo se gestiona con git; cualquier archivo nuevo debe estar trackeado para que el flake lo vea (`git add`).
- Backup de configuraciones antiguas en `bak/` (ignorado por git).