{ pkgs, inputs, ... }:
{
  imports = [
    ./home/kitty.nix
    ./home/screensaver.nix
    ./home/hyprlock.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

# custom screensaver
 programs.screensaver = {
    enable = true;
    artFile = ./art.txt;   # or set `art = '' ... '';` inline
      lockCommand = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    idleSeconds = 120;
  };
}

