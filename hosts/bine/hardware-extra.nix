{ pkgs, ... }: {
  # Firmware & Updates. fwupd is already enabled by the
  # nixos-hardware framework-amd-ai-300-series module; the testing remote
  # gives us access to Framework BIOS betas pushed to LVFS.
  services.fwupd.extraRemotes = [ "lvfs-testing" ];
  hardware.enableRedistributableFirmware = true;

  # Fingerprint Reader
  services.fprintd.enable = true;
  security.pam.services.gdm-fingerprint.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.gnome-screensaver.fprintAuth = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Audio (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Other Hardware
  services.libinput.enable = true; # Touchpad
  services.hardware.bolt.enable = true; # Thunderbolt
  hardware.sensor.iio.enable = false; # Disable light sensors (save battery)
  services.pcscd.enable = true; # Smartcard
  services.udev.packages = [ pkgs.yubikey-personalization ];
  
  # Power Management
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "suspend";
  };

  # Compressed swap-in-RAM. Cheap insurance against memory pressure under
  # docker / browser / nix builds; no disk swap needed.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
