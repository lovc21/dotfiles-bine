{ lib, pkgs, config, ... }:
{
  specialisation = {
    "BatterySaver".configuration = {
      system.nixos.tags = [ "BatterySaver" ];

      # CPU Power Management
      powerManagement.cpuFreqGovernor = "powersave";

      # Disable high-drain hardware/services
      hardware.bluetooth.enable = lib.mkForce false;
      programs.steam.enable = lib.mkForce false;
      
      systemd.services.dim-screen = {
        description = "Dim screen for battery saving";
        after = [ "graphical.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl set 45%";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
