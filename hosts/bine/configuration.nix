# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #BIOS upgrade
  services.fwupd.enable = true;
  
  # Enable redistributable firmware
  hardware.enableRedistributableFirmware = true;
  
 # MT7925 firmware is available
  hardware.firmware = with pkgs; [ 
    linux-firmware 
  ];


  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Install the latest kernel from the NixOS channel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Install a specific kernel version from the NixOS channel
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_6_17);
  
  # Add kernel parameters to better support suspend (i.e., "sleep" feature)

  # Use minimal kernel parameters, including one that turns off ASPM,
  # which seems to enable suspend to work on the Framework 13 AMD laptop when using a dock
  boot.kernelParams = [ "mem_sleep_default=s2idle" "amdgpu.dcdebugmask=0x10" "pcie_aspm=off" ];

  # Configure how the system sleeps when the lid is closed;
  # specifically, it should sleep or suspend in all cases
  # --> when running on battery power
  # --> when connected to external power
  # --> when connected to a dock that has external power
  services.logind.settings.Login.HandleLidSwitch = "suspend";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "suspend";
  services.logind.settings.Login.HandleLidSwitchDocked = "suspend";


  # Configure the automatic mounting of external
  # USB drives; note that they are mounted according
  # to the user that is active, meaning that it can
  # be the lightdm user when the system is booting
  # or, otherwise, the user that is logged in
  services.devmon.enable = true;
  services.gvfs.enable = true;  
  
  networking.hostName = "bine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Disable the firewall so that other
  # services can connect to localhost
  networking.firewall.enable = false;

  # Automatically set the regulatory domain for
  # the wireless network card
  hardware.wirelessRegulatoryDatabase = true;

  # Disable light sensors and accelerometers as
  # they are not used and consume extra battery
  hardware.sensor.iio.enable = false;

  # Enable tailscale by default; note that this
  # installs the cli-based program and runs the daemon
  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sl_SI.UTF-8";
    LC_IDENTIFICATION = "sl_SI.UTF-8";
    LC_MEASUREMENT = "sl_SI.UTF-8";
    LC_MONETARY = "sl_SI.UTF-8";
    LC_NAME = "sl_SI.UTF-8";
    LC_NUMERIC = "sl_SI.UTF-8";
    LC_PAPER = "sl_SI.UTF-8";
    LC_TELEPHONE = "sl_SI.UTF-8";
    LC_TIME = "sl_SI.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Install fonts; note that this ensures the Nerd fonts
  # with all of their affiliated symbols are applied
  # to the fonts that are installed from Nix packages
  fonts.packages = with pkgs; [
    maple-mono.NF
    maple-mono.Normal-NF
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.roboto-mono
  ];


  # Enable the fingerprint reader
  services.fprintd.enable = true;
  
  # Enable fingerprint authentication for login
  security.pam.services.gdm-fingerprint.fprintAuth = true;
  # Enable for sudo and screensaver
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.gnome-screensaver.fprintAuth = true;
  
  # Enable support for Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME="gtk3";
  };

  # YubiKey udev rules
  services.udev.packages = [ pkgs.yubikey-personalization ];
  
  # Smartcard support (if GPG key)
  services.pcscd.enable = true;
  
  # GPG agent with SSH (if it's a GPG key on YubiKey)
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };


  # Enable nix-ld so that it is possible
  # to install pre-compiled binaries that
  # that expect libraries to be in standard FHS
  # locations; this is especially helpful for
  # the installation of Python programs that
  # have C, C++, or Rust extensions
  programs.nix-ld.enable = true;

   # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     # Tools
     vim
     wget
     curl
     tmux
     tree
     just

     # System tools
     pciutils
     usbutils
     lm_sensors
     killall
     file
  
     # Network tools
     networkmanagerapplet
     wirelesstools
     iw
  
    # Build tools
    gcc
    gnumake
    pkg-config
  
    # NixOS-specific
    nix-tree
    nix-index
    nixos-option
  
    # Power management
    powertop
    acpi
  
    # Git
    git
    git-lfs
    git-extras
    
    # GTK Theme
    tokyonight-gtk-theme
    
    # Icon theme that matches Tokyo Night
    papirus-icon-theme
    tela-circle-icon-theme
    
    # Cursor theme
    bibata-cursors
    
    # Theme tools
    gnome-tweaks
    dconf-editor


  ];

  programs.dconf.enable = true;
  
  # Set Tokyo Night as default theme
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    gtk-theme='Tokyonight-Dark'
    icon-theme='Papirus-Dark'
    cursor-theme='Bibata-Modern-Ice'
    color-scheme='prefer-dark'
  '';
	
  # Enable zsh 
  programs.zsh.enable = true;

  # === SERVICES ===
  virtualisation.docker.enable = true;

  # Enable the bolt protocol for thunderbolt docks
  services.hardware.bolt.enable = true;

  # Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;
  
  # Disable gnome-keyring entirely for SSH
  environment.variables = {
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };
  # Enable for GDM (not lightdm!)
  security.pam.services.gdm.enableGnomeKeyring = true;

  system.stateVersion = "25.11";

}
