{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  # Define your custom packages here
  ai-usagebar = pkgs.callPackage ./ai-usagebar { };
}
