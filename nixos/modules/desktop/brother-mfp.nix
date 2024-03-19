{ config, pkgs, lib, ... }:

let
  cfg = config.my.desktop.brotherMfp;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  options.my.desktop.brotherMfp = {
    enable = lib.mkEnableOption "printing and scanning with Brother MFP";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence."/persist" = {
        directories = [
          { directory = "/var/lib/cups"; mode = "u=rwx,g=rx,o=rx"; }
          {
            directory = "/var/cache/cups";
            group = "lp";
            mode = "u=rwx,g=rwx,o=";
          }
        ];
      };
    };

    fonts.enableDefaultPackages = lib.mkDefault true;

    hardware.sane = {
      enable = true;
      brscan4 = lib.mkIf (system == "x86_64-linux") {
        enable = true;
        netDevices = {
          home = {
            model = "DCP-L2560DW";
            nodename = "mfp.home.arpa";
          };
        };
      };
    };

    services.printing.enable = true;

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Brother_DCP_L2560DW";
          location = "Home";
          deviceUri = "ipp://mfp.home.arpa:631/ipp/print";
          model = "drv:///sample.drv/generic.ppd";
          ppdOptions = {
            PageSize = "A4";
          };
        }
      ];
      ensureDefaultPrinter = "Brother_DCP_L2560DW";
    };
  };
}
