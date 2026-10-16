{ ... }: {
  imports = [
    ./terraform.nix
    ./kubernetes.nix
    ./docker.nix
    ./devcontainers.nix
    ./cloud.nix
    ./hashicorp.nix
    ./security.nix
  ];
}
