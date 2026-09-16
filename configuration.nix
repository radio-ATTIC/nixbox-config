# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixbox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
networking.wireless.iwd.enable = true;

  # Disk mount
fileSystems."/mnt/cachy-home" = {
  device = "/dev/disk/by-uuid/01974971-eb3e-4b8e-89c3-c12bce67396f";
  fsType = "btrfs";
  options = [ "subvol=@home" ];  # replace with the real subvol name from step 2
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

# Fonts

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
	firefox
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
  bottom
  impala
  atuin
  rebels-in-the-sky
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
];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
