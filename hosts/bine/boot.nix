{ pkgs, ... }: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # amdgpu.dcdebugmask=0x10 disables PSR (fixes cursor stutter on eDP).
  # s2idle is already the default on AI 300 and pcie_aspm=off costs battery.
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
}
