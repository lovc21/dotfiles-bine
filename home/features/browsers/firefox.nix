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
  firefoxPkg = pkgs.firefox.override {
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
        "browser.tabs.unloadOnLowMemory" = pref true;
        "browser.low_commit_space_threshold_percent" = pref 50;
        "browser.low_commit_space_threshold_mb" = pref 15360;
        "browser.tabs.min_inactive_duration_before_unload" = pref 300000;
        "dom.ipc.processCount.webIsolated" = pref 1;
      };
      "3rdparty".Extensions."{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
        period = 300;
        number = 4;
        memory-enabled = true;
        memory-value = 400;
        startup-unpinned = true;
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
  };
in
{
  options.features.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    systemd.user.slices.firefox.Slice.MemoryHigh = "8G";

    home.packages = [
      (pkgs.symlinkJoin {
        name = "firefox-capped";
        paths = [
          (pkgs.writeShellScriptBin "firefox" ''
            exec ${pkgs.systemd}/bin/systemd-run --user --scope --quiet --collect --slice=firefox.slice ${firefoxPkg}/bin/firefox "$@"
          '')
          firefoxPkg
        ];
      })
    ];
  };
}
