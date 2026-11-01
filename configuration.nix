
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
networking.wireless.iwd.settings = {
   Rank.BandModifier5Ghz = 0.0;
};
# BandModifier2_4GHz = 0.0

  # Disk mount
fileSystems."/mnt/cachy-home" = {
  device = "/dev/disk/by-uuid/01974971-eb3e-4b8e-89c3-c12bce67396f";
  fsType = "btrfs";
  options = [ "subvol=@home" ];  
};

  # Set your time zone.
  time.timeZone = "Europe/France";

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
		command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
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
    xdg-desktop-portal-gtk
    xdg-desktop-portal-termfilechooser
  ];
  config.common.default = [ "gtk" ];
};

# Fonts
# Mpd
services.mpd = {
  enable = true;
  musicDirectory = "/home/radio/Music";
  user = "radio";
  settings = {
    audio_output = [
      {
        type = "pipewire";
        name = "PipeWire Output";
      }
    ];
  };
};

# watt
services.watt.enable = true;
services.watt.settings.rule = [
  {
    name = "battery-thresholds";
    priority = 10;
    power.for = [ "BAT0" ];
    power.charge-threshold-start = 75;
    power.charge-threshold-end = 85;
  }
];
systemd.services.watt.environment.WATT_CONFIG = "/etc/watt.toml"; 

# Syncthing
services.syncthing = {
  enable = true;
  user = "radio";
  dataDir = "/home/radio";
  configDir = "/home/radio/.config/syncthing";
  openDefaultPorts = true;
};
# session Variables
environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";  # insert theme name
  QT_QPA_PLATFORMTHEME = "qt6ct";

};

# Swaylock PAM
security.pam.services.swaylock = {};

# Niri
programs.niri.enable = true;

# Packages
environment.systemPackages = with pkgs; [
	rofi
	waybar
	wget
	fastfetch
	wl-clipboard
	zoxide
	awww
	wlogout
	yazi
	swaynotificationcenter
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
  hypridle
  hyprlock
  grim
  slurp
  swappy
  timr-tui
  glow
  github-cli
  dconf
  xdg-desktop-portal-termfilechooser
  swayimg
  imv
  nix-output-monitor
  socat
  rmpc
  mpc
  tuigreet
  regreet
  android-tools
  scrcpy
  sherlock
  whatsie
  wf-recorder
  mpv
  ffmpeg
  yt-dlp
  pkgs.bibata-cursors
  losslesscut
  prismlauncher
  ani-cli
  ani-skip
  litecli
  tree
  gnirehtet
  xwayland-satellite
  imagemagick
  ripgrep
  doppler
  jq
  starship
  swaybg
  swaylock
  ollama
  dm-mono
];

# tuigreet
environment.etc."tuigreet/config.toml".text = ''
  [display]
  show_time = true
  greeting = "welcome"

  [remember]
  username = true
  user_session = true

  [secret]
  mode = "characters"
  characters = "*"

  [theme]
  border = "blue"
  text = "white"
  container = "black"
  prompt = "cyan"
  input = "blue"
  action = "white"
  button = "blue"
  time = "cyan"

'';

 system.stateVersion = "26.05"; # Did you read the comment?

}
