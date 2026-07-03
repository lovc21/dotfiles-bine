{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "ai-usagebar";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "akitaonrails";
    repo = "ai-usagebar";
    tag = "v${version}";
    hash = "sha256-2+A2JxJuXbw8YZLmVcEuLOBTEIriIIx1wV6nIoemF7s=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  # The tool talks to live OAuth/API endpoints; its tests need network, which
  # the build sandbox does not have.
  doCheck = false;

  meta = {
    description = "Waybar widget + TUI for AI plan usage (Anthropic, OpenAI, Z.AI, OpenRouter, DeepSeek)";
    homepage = "https://github.com/akitaonrails/ai-usagebar";
    license = lib.licenses.mit;
    mainProgram = "ai-usagebar";
    platforms = lib.platforms.unix;
  };
}
