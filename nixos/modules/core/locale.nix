{ ... }:

{
  time.timeZone = "Europe/Budapest";

  i18n = {
    # Substitute for the non-exisiting Paneuropean English locale
    defaultLocale = "en_IE.UTF-8";
    # Set ISO date & time
    extraLocaleSettings = { LC_TIME = "en_DK.UTF-8"; };
  };
}
