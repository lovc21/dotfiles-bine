{ pkgs, ... }: {
  # Firmware & Updates
  # BIOS upgrade
  services.fwupd.enable = true;
  # Enable redistributable firmware
  hardware.enableRedistributableFirmware = true;
  # MT7925 firmware is available
  hardware.firmware = [ pkgs.linux-firmware ];

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
    HandlePowerKey = "suspend";
  };
}
