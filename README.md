# nixbox

My personal NixOS configuration for `nixbox` — a ThinkPad T14 Gen 1 (AMD Ryzen 5 PRO 4650U) dual-booting alongside CachyOS/KDE, built around a TUI/CLI-first workflow on Hyprland.

## Overview

- **WM:** [Hyprland](https://hyprland.org/) (Lua config), with `hypridle` + `hyprlock` for idle/lock
- **Login:** `greetd` + `tuigreet`
- **Shell:** fish, with `starship`, `zoxide`, `atuin`, `fzf`
- **File manager:** `yazi`
- **Terminal tools:** `btop`, `lazygit`, `timr-tui`, `fastfetch`, `impala`
- **Shared storage:** `/mnt/cachy-home` — the CachyOS btrfs home subvolume, mounted read/write so games and files (managed via [Heroic](https://heroicgameslauncher.com/)) are shared between both OS installs without duplicating anything

## Structure
├── flake.nix # entrypoint — pins nixpkgs, defines the nixbox system
├── flake.lock # pinned input versions
└── configuration.nix # main system config

Currently a minimal flake wrapping a fairly traditional `configuration.nix` — no home-manager yet, still learning the flakes model one step at a time.

## Notable setup notes

- Hyprland is installed via `programs.hyprland` (not as a bare package) so its systemd session integration (`hyprland-session.target`) works correctly with portals/idle/lock.
- `/mnt/cachy-home` is mounted via UUID + explicit btrfs `subvol=`, no `uid`/`gid` options (not valid on btrfs).

## Usage

```bash
sudo nixos-rebuild switch --flake .#nixbox
```

## Disclaimer

This is my personal daily-driver config — shared for reference, not intended as a drop-in template. Hardware-specific bits (mount UUIDs, host name, user) will need adjusting for any other machine.
