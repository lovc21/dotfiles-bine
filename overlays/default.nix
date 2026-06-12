{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # TODO: remove once nixpkgs pipx test failures are fixed upstream (whitespace handling in PEP 508 `pkg @ url` specs).
    pipx = prev.pipx.overridePythonAttrs (_: { doCheck = false; });

    # TODO: remove once nixpkgs catches up; pins ahead of nixpkgs for newest models.
    claude-code = prev.claude-code.overrideAttrs (_: rec {
      version = "2.1.173";
      src = prev.fetchurl {
        url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude";
        sha256 = "cf7ea194e1748932fa30f180eaa9f56f9a7039dce370302988c2926629b2a219";
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

