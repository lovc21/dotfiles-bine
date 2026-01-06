{ pkgs, ... }: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Kernel params for Framework 13 AMD
  boot.kernelParams = [ "mem_sleep_default=s2idle" "amdgpu.dcdebugmask=0x10" "pcie_aspm=off" ];
}
