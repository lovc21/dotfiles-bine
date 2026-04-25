{ config, lib, pkgs, ... }:

let
  cfg = config.features.devops.kubernetes;
in {
  options.features.devops.kubernetes.enable = lib.mkEnableOption "kubernetes tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
      kubectx
      k9s
      kubernetes-helm
      argocd
    ];
  };
}
