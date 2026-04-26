{ pkgs, ... }: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # amdgpu.dcdebugmask=0x10 disables PSR (fixes cursor stutter on eDP).
  # amdgpu.mes=0 disables the MES scheduler — workaround for the well-known
  # Ryzen AI 300 freeze on display/USB hotplug events (Framework forum #71364).
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" "amdgpu.mes=0" ];
}
