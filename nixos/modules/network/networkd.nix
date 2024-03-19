{ inputs, config, pkgs, lib, ... }:

let
  interfacesOf = config: config.my.network.interfaces;

  ifaces = interfacesOf config;

  # Links

  mkLink = kind: iface: macAddress: lib.nameValuePair "10-${iface}"
    {
      matchConfig.PermanentMACAddress = macAddress;
      linkConfig = {
        Name = iface;
        WakeOnLan = lib.mkIf (kind == "wired") "magic";
      };
    };

  wiredLinks = lib.mapAttrs' (mkLink "wired") ifaces.wired;
  wirelessLinks = lib.mapAttrs' (mkLink "wireless") ifaces.wireless;

  # Networks

  mkWiredNetwork = iface: _: lib.nameValuePair "20-${iface}"
    {
      matchConfig.Name = iface;
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";

      # Increase priority, i.e. lower route metrics for the routes for wired
      # networks so the wired connection is preferred over the wireless one if
      # available.
      # https://unix.stackexchange.com/questions/555500/how-to-change-the-order-of-the-default-gateway-with-systemd-networkd
      dhcpV4Config = {
        RouteMetric = 1020; # default is 1024
      };
      ipv6AcceptRAConfig = {
        RouteMetric = 508; # default is "512:1024:2048"
      };
    };

  wiredNetworks = lib.mapAttrs' mkWiredNetwork ifaces.wired;

  mkEnvVar = hostName: iface: macAddress: lib.nameValuePair
    "MY_${lib.toUpper hostName}_${lib.toUpper iface}"
    macAddress;

  wiredEnvVars = lib.concatMapAttrs
    (hostName: ifaces: lib.mapAttrs' (mkEnvVar hostName) ifaces)
    (
      builtins.mapAttrs
        (n: v: (interfacesOf v.config).wired)
        inputs.self.nixosConfigurations
    );

in
{
  options.my.network.interfaces = {
    wired = lib.mkOption {
      type = lib.types.attrsOf lib.types.nonEmptyStr;
      default = { };
      description = ''physical (MAC) addresses of wired interfaces'';
    };
    wireless = lib.mkOption {
      type = lib.types.attrsOf lib.types.nonEmptyStr;
      default = { };
      description = ''physical (MAC) addresses of wireless interfaces'';
    };
  };

  config = {
    # Unmanage all wired network interfaces
    networking.networkmanager.unmanaged = builtins.attrNames ifaces.wired;

    systemd.network = {
      enable = true;
      links = wiredLinks // wirelessLinks;
      networks = wiredNetworks;
    };

    environment = {
      # Make environment variables containing the MAC addresses of wired
      # network interfaces for WoL
      sessionVariables = wiredEnvVars;
      systemPackages = [ pkgs.wol ];
    };
  };
}
