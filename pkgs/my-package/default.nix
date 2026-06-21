# Your custom nix-package
# ...
{
  writeShellScriptBin,
}:
writeShellScriptBin "my-package" ''
  echo "hello from my-package"
''
