{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    # TODO: remove once nixpkgs catches up; pins ahead of nixpkgs for newest models.
    claude-code = prev.claude-code.overrideAttrs (_: rec {
      version = "2.1.212";
      src = prev.fetchurl {
        url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude";
        sha256 = "044a88cf3a5180776617fd3da1238dcbf9141ddec449a39cf7d2af1ac78e684e";
      };
    });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
