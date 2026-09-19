
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixbox"; # hostname
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


networking.wireless.iwd.enable = true;

  # Disk mount
fileSystems."/mnt/cachy-home" = {
  device = "/dev/disk/by-uuid/01974971-eb3e-4b8e-89c3-c12bce67396f";
  fsType = "btrfs";
  options = [ "subvol=@home" ];  
};

  # Set your time zone.
  time.timeZone = "Africa/Casablanca";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account
  users.users."radio" = {
    isNormalUser = true;
    description = "Radioattic";
    extraGroups = [ "video" "audio" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Login 
  services.greetd = {
	enable = true;
	settings = {
		default_session = {
		command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
		};
	};
};

# Flakes toggle
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Graphics / polkit
hardware.graphics.enable = true;
security.polkit.enable = true;

# Audio / Pipewire
services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
};

# rtkit
security.rtkit.enable = true;

# Bluetooth
hardware.bluetooth.enable = true;

# Shell
programs.fish.enable = true;

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# Yazi as the file picker
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-termfilechooser
  ];
  config.common.default = [ "hyprland" "gtk" ];
};

# Fonts

# session Variables
environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";  # insert theme name
  QT_QPA_PLATFORMTHEME = "qt6ct";
};

# Hyprland
programs.hyprland = {
  enable = true;
  package = pkgs.hyprland.override { withSystemd = true; };
  xwayland.enable = true;
};

# Packages
environment.systemPackages = with pkgs; [
	kitty
	rofi
	waybar
	wofi
	git
	wget
	fastfetch
	wl-clipboard
	zoxide
	awww
	wlogout
	yazi
	swaynotificationcenter
	fzf
	pavucontrol
	lm_sensors
	upower
	btop
	appimage-run
	unzip
	thunar
	obsidian
	yank
	neovim
  gcc
  tree-sitter
  lazygit
  delta
  impala
  atuin
  tldr
  brightnessctl
  pkgs.swayosd
  localsend
  nerd-fonts.jetbrains-mono
  duf
  taskwarrior3
  taskwarrior-tui
  hypridle
  hyprlock
  tty-clock
  grim
  slurp
  swappy
  hyprshot
  timr-tui
  equibop
  glow
  github-cli
  dconf
  xdg-desktop-portal-termfilechooser
  swayimg
  imv
  nix-output-monitor
  socat
  mpd
];

 system.stateVersion = "26.05"; # Did you read the comment?

}
