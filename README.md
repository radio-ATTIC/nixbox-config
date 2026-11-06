# nixbox

My personal NixOS configuration for `nixbox`, a ThinkPad T14 Gen 1. A single flake describes the whole machine: the system (`configuration.nix`) and my user environment (Home Manager), with a TUI/CLI-first workflow on the [niri](https://github.com/YaLTeR/niri) scrolling Wayland compositor.

<!-- TODO: add a screenshot here (e.g. docs/screenshot.png) once the theming is finished -->

## Overview

| | |
|---|---|
| **Compositor** | niri (`programs.niri.enable`), with `xwayland-satellite` for X11 apps |
| **Login** | greetd + [ReGreet](https://github.com/rharish101/ReGreet), Gruvbox-Dark GTK theme, Papirus-Dark icons, Bibata cursor, `wallpaper.png` background |
| **Shell** | fish, with starship, zoxide, atuin, fzf |
| **Terminal / launcher / bar** | kitty (via Home Manager) / rofi + sherlock / waybar |
| **Lock / idle / notifications** | swaylock, hypridle, swaync, swayosd |
| **Files** | yazi (also set up as the file-picker portal), thunar |
| **Browser** | LibreWolf |
| **Networking** | iwd, managed with `impala` (TUI) |
| **Audio / Bluetooth** | PipeWire (ALSA, PulseAudio, 32-bit) / BlueZ |
| **Gaming** | Steam + Proton-GE, gamescope, gamemode, mangohud, umu-launcher, Heroic |
| **Power** | `watt` with battery charge thresholds (75% start, 85% stop), zram swap |
| **Other services** | Syncthing, Flatpak, udisks2 |
| **Boot** | systemd-boot (EFI) |
| **Channel** | `nixos-unstable`, `stateVersion` 26.05 |

## Structure

```
.
├── flake.nix                   # entrypoint: pins nixpkgs + home-manager, defines nixosConfigurations.nixbox
├── flake.lock                  # pinned input versions
├── configuration.nix           # system config (services, drivers, system packages, regreet, niri)
├── hardware-configuration.nix  # generated for this machine (filesystems, kernel modules)
├── home.nix                    # Home Manager entrypoint for user `radio`, imports ./home/*
├── home/                       # Home Manager modules, e.g. kitty.nix
│   └── ...                     # <!-- TODO: list the rest of the files in home/ -->
└── wallpaper.png               # used by ReGreet
```

## How it fits together

`flake.nix` builds one system, `nixbox`, from two parts:

1. **`configuration.nix`**: everything that needs root or is system-wide.
2. **Home Manager**, plugged in as a NixOS module (`home-manager.nixosModules.home-manager`), which applies `home.nix` for user `radio`. Because it is a module, a single `nixos-rebuild` updates both the system and the user environment; there is no separate `home-manager switch`.

Home Manager is set to use the system's `pkgs` (`useGlobalPkgs`) and install into the user profile (`useUserPackages`). Existing files that it would overwrite are renamed with a `.bak` extension.

User-level programs are being migrated into `home/` gradually, configured through Nix options (for example `programs.kitty.settings`) instead of hand-written dotfiles.

## Usage

```sh
# Build and switch to the new config
sudo nixos-rebuild switch --flake .#nixbox

# Build now, activate on next boot (safer for risky changes)
sudo nixos-rebuild boot --flake .#nixbox

# Update inputs (nixpkgs, home-manager), then rebuild
nix flake update
sudo nixos-rebuild switch --flake .#nixbox

# Roll back to the previous generation
sudo nixos-rebuild switch --rollback
```

Flakes only see files tracked by git, so run `git add` on any new file before rebuilding.

## Notes

- **niri** is enabled through `programs.niri`, so its session and portal integration come from the NixOS module rather than a bare package.
- **File picker:** `xdg-desktop-portal-termfilechooser` is configured so yazi acts as the file chooser, with the GTK portal as the default fallback.
- **Wi-Fi:** iwd's `BandModifier5Ghz` is set to `0.0` so it does not prefer 5 GHz over 2.4 GHz, which helps with stability when the signal is weak.
- **Battery:** charge thresholds are applied to `BAT0` through `watt`.

## Disclaimer

This is my personal daily-driver config, shared for reference and not meant as a drop-in template. Hardware-specific parts (`hardware-configuration.nix`, hostname, username) will need adjusting for any other machine.
