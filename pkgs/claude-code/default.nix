# To bump to the latest release, run: just update-claude
{
  claude-code,
  fetchurl,
}:

claude-code.overrideAttrs (_: rec {
  version = "2.1.286";
  src = fetchurl {
    url = "https://downloads.claude.ai/claude-code-releases/${version}/linux-x64/claude.zst";
    hash = "sha256-oU2ARDRzEm5Ay8UOt4iZ9D6PTUM2CVhj+Aiaa5ygKpc=";
  };
})
