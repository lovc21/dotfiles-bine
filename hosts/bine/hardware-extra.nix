{ pkgs, ... }: {
  # Firmware & Updates. fwupd is already enabled by the
  # nixos-hardware framework-amd-ai-300-series module; the testing remote
  # gives us access to Framework BIOS betas pushed to LVFS.
  services.fwupd.extraRemotes = [ "lvfs-testing" ];
  hardware.enableRedistributableFirmware = true;

  # Framework Control (fan curves, power profiles, battery charge limit)
  # Config is declarative: edit framework-control-config.json and rebuild,
  # then restart the service. UI edits get reverted on the next rebuild.
  services.framework-control.enable = true;
  environment.etc."framework-control/config.json".source = ./framework-control-config.json;

  # Fingerprint Reader
  services.fprintd.enable = true;
  security.pam.services.gdm-fingerprint.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.hyprlock.fprintAuth = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  # Apple vendor DeviceID so AirPods expose battery/noise-control to librepods;
  # AirPods cache this, so re-pair them after the first rebuild.
  hardware.bluetooth.settings.General.DeviceID = "bluetooth:004C:0000:0000";

  # Audio (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Dummy AVRCP player so AirPods media controls (play/pause/skip) work
    wireplumber.extraConfig."51-bluez-avrcp" = {
      "monitor.bluez.properties"."bluez5.dummy-avrcp-player" = true;
    };
  };

  # Bring up the AMD ACP (SOF) digital microphone on the Ryzen AI 300.
  # The internal mic lives on the ACP 7.0 coprocessor and needs the SOF
  # driver + firmware; without these it never binds and PipeWire falls
  # back to the dead ALC285 HDA pin (constant static).
  hardware.firmware = [ pkgs.sof-firmware ];
  boot.kernelModules = [ "snd_sof_amd_acp70" ];

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

  # The PixArt I2C touchpad arms itself as a wakeup source and blocks suspend, Keyboard / power / lid still wake up
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="i2c", ATTR{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
  '';

  # Compressed swap-in-RAM. Cheap insurance against memory pressure under
  # docker / browser / nix builds; no disk swap needed.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
