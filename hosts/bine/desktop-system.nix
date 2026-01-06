{ pkgs, ... }: {
  # X11 & GDM
  services.xserver.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Hyprland (System Level)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    maple-mono.NF
    maple-mono.Normal-NF
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.roboto-mono
  ];

  # Security / Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  # Disable gnome-keyring entirely for SSH
  environment.variables = {
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };
}
