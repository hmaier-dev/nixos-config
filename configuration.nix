# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false; # true won't write LoaderSystemToken on my ASUS-Board

  networking.hostName = "nixos-hendrik"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.dhcpcd = {
	enable = true;
	extraConfig = ''
		static ip_address=192.168.178.104/24
		static routers=192.168.178.1
	'';
  };

  time.timeZone = "Europe/Berlin"; # Set your time zone.
  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };
  services.xserver = {

    enable = true;
    layout = "de";
    xkbOptions = "eurosign:e,caps:escape";
    
    desktopManager.xfce = {
      enable = true;
      enableXfwm = false;
    };
    windowManager.bspwm = {
      enable = true;
      configFile = "/home/hmaier/.config/bspwm/bspwmrc";
      sxhkd.configFile = "/home/hmaier/.config/sxhkd/sxhkdrc";
    };
    displayManager.lightdm = {
      enable = true;
    };
    displayManager.sessionCommands = ''
      source $HOME/.config/bspwm/bspwmrc
      ${pkgs.bspwm}/bin/bspc wm -r 
    '';

    # displayManager.sessionCommands = ''
    #   ${pkgs.bspwm}/bin/bspc wm -r 
    #   source $HOME/.config/bspwm/bspwmrc
    # '';
  };

#  services.xserver.displayManager.gdm.enable = true;
#  programs.hyprland = {
#    enable = true;
#  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
 users.users.hmaier = {
   uid = 1001;
   isNormalUser = true;
   initialPassword = "hmaier";
   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
 };

 fileSystems."/home/hmaier/share" = {
	device = "//192.168.178.99/nas/private_hdd/Share";
	fsType = "cifs";
	options = [ "uid=1001" "gid=1001" "pass=sharingiscaring" "user=share" "rw" ];
		# automount_opts = "x-systemd.automount, noauto, x-systemd.idle-timeout=60, x-systemd.device-timeout=5s, x-systemd.mount-timeout=5s";
	# [ "${automount_opts}" "uid=1001" "gid=1001" "pass=sharingiscaring" "user=share"];

 };
	
	# Allow proprietary licence for following packages
	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
				 "steam"
				 "steam-original"
	];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [

	 keepassxc
	 neovim
	 steam
	 syncthing
	 wmname
     bat
     brave
     bspwm
     cifs-utils
     curl
     doas
     exa
     feh
     fzf
     git
     htop
     kitty
     lightdm
     lsb-release
     mate.mate-polkit
     neofetch
     nerdfonts
     openssl
     polybar
     python3
	 font-manager
     rofi-wayland
     scrot
     sxhkd
     vim 
     waybar
     wget
     xclip
     xfce.thunar
     xfce.xfce4-terminal
     yt-dlp
     zathura

   ];

#  programs.neovim = {
#    enable = true;
#    defaultEditor = true;
#    configure = {
#  	customRC = ''
#  	  colorscheme pablo
#  	  set number relativenumber
#  	  '';
#    };
#  };

  fonts.fonts = (with pkgs; [
    source-code-pro
	nerdfonts
  ]);

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

