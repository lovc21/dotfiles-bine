{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.browsers.firefox;
  extension = slug: {
    installation_mode = "normal_installed";
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
  };
  pref = value: {
    Value = value;
    Status = "default";
  };
in
{
  options.features.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.firefox.override {
        extraPolicies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
            Fallback = false;
          };
          FirefoxSuggest = {
            SponsoredSuggestions = false;
            ImproveSuggest = false;
          };
          Preferences = {
            "browser.contentblocking.category" = pref "strict";
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = pref false;
            "browser.newtabpage.activity-stream.showSponsored" = pref false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = pref false;
          };
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = extension "ublock-origin";
            "@testpilot-containers" = extension "multi-account-containers";
            "jid1-MnnxcxisBPnSXQ@jetpack" = extension "privacy-badger17";
            "gdpr@cavi.au.dk" = extension "consent-o-matic";
            "{443bc2e2-8fa9-44ec-828a-fd84c0664f8d}" = extension "gifs-for-github";
            "vimium-c@gdh1995.cn" = extension "vimium-c";
            "bibitnow018@aqpl.mc2.chalmers.se" = extension "bibitnow";
            "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = extension "auto-tab-discard";
            "{f4961478-ac79-4a18-87e9-d2fb8c0442c4}" = extension "global-speed";
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = extension "return-youtube-dislikes";
          };
        };
      })
    ];
  };
}
