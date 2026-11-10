# To bump to the latest release, run: just update-claude
{
  claude-code,
  fetchurl,
}:

claude-code.overrideAttrs (_: rec {
  version = "2.1.322";
  src = fetchurl {
    url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude.zst";
    hash = "sha256-m7dVi9mSykV+ZFi/FoZXL3oxVrgzHdhEM5Hb/lkMHu0=";
  };
})
