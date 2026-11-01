{ pkgs, inputs, ... }:
{
  imports = [
    ./home/kitty.nix
    ./home/git.nix
    ./home/shell.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
