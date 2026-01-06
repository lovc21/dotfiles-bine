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
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      maple-mono.NF
      maple-mono.Normal-NF
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.monaspace
      nerd-fonts.roboto-mono

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      serif = [ "Source Han Serif SC" "Noto Color Emoji" ];
      sansSerif = [ "Source Han Sans SC" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Security / Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  # Disable gnome-keyring entirely for SSH
  environment.variables = {
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };
}



