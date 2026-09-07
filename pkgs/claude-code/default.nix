# To bump to the latest release, run: just update-claude
{
  claude-code,
  fetchurl,
}:

claude-code.overrideAttrs (_: rec {
  version = "2.1.263";
  src = fetchurl {
    url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude";
    hash = "sha256-JtAgNR6BEvQAZ5Dzz85DtMnfDBux0OVCNk1kFRuB1bo=";
  };
})
