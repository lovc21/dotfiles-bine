{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./steam.nix
      ./boot.nix
      ./hardware-extra.nix
      ./desktop-system.nix
      ./locale.nix
      ./specialisations.nix
      ./stylix.nix
    ];
  
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Automatically set the regulatory domain for
  # the wireless network card
  hardware.wirelessRegulatoryDatabase = true;

  # Enable tailscale by default; note that this
  # installs the cli-based program and runs the daemon
  services.tailscale.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # GPG agent with SSH (if it's a GPG key on YubiKey)
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
    # pinentryPackage = pkgs.pinentry-gnome3;
  };


  # Enable nix-ld so that it is possible
  # to install pre-compiled binaries that
  # that expect libraries to be in standard FHS
  # locations; this is especially helpful for
  # the installation of Python programs that
  # have C, C++, or Rust extensions
  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim               
    pciutils          # system hardware diagnostics
    usbutils          # system hardware diagnostics
    lm_sensors        # system temperature monitoring
    killall           # basic system tool
    file              # basic system tool
    wirelesstools     # system networking
    iw                # system networking
    nix-tree          # NixOS tooling
    nix-index         # NixOS tooling
    nixos-option      # NixOS tooling
    powertop          # system power management
    acpi              # system power info
  ];


  # Wayland environment variables
  environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  GDK_BACKEND = "wayland,x11";
  QT_QPA_PLATFORM = "wayland;xcb";
  MOZ_ENABLE_WAYLAND = "1";
  };

  programs.dconf.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/bine/jakob-stuff/dotfiles-bine";
  };

  # Enable zsh
  programs.zsh.enable = true;

  # === SERVICES ===
  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";

}
