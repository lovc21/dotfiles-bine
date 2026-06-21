_:
{
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;
  programs.deadnix.enable = true;
  programs.statix.enable = true;

  settings.global.excludes = [
    "*.lock"
    "*.png"
    "*.jpg"
    "*.jpeg"
    "*.lst"
  ];
}
