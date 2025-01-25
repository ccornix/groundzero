{ config, lib, pkgs, ... }:

let
  cfg = config.my.zfs;

  rootBlankSnapshot = "rpool/local/root@blank";

  rootDiffScript = pkgs.writeShellScriptBin "my-root-diff" ''
    sudo ${pkgs.zfs}/bin/zfs diff ${rootBlankSnapshot}
  '';
in
{
  options.my.zfs = {
    enable = lib.mkEnableOption "custom ZFS configuration and services";
    arcMaxMiB = lib.mkOption {
      type = lib.types.int;
      default = 1024;
      description = ''
        Maximal size of the ZFS ARC cache. Zero means dynamically managed by
        ZFS.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # NOTE: no longer works
    # boot.initrd.postDeviceCommands = lib.mkAfter ''
    #   zfs rollback -r ${rootBlankSnapshot}
    # '';

    boot = {
      kernelParams = [
        "nohibernate"
        # WORKAROUND: get rid of error
        # https://github.com/NixOS/nixpkgs/issues/35681
        "systemd.gpt_auto=0"
      ] ++ lib.optional (cfg.arcMaxMiB > 0)
        "zfs.zfs_arc_max=${toString (cfg.arcMaxMiB * 1048576)}";

      supportedFilesystems = [ "zfs" ];

      initrd.systemd = {
        enable = lib.mkDefault true;
        services.initrd-rollback-root = {
          description = "Rollback root dataset";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-rpool.service" ];
          before = [ "sysroot.mount" ];
          # Prevent system errors like:
          # Job local-fs.target/start deleted to break ordering cycle starting with initrd-rollback-root.service/start
          # Job systemd-tmpfiles-setup.service/start deleted to break ordering cycle starting with initrd-rollback-root.service/start
          unitConfig.DefaultDependencies = "no";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${config.boot.zfs.package}/sbin/zfs rollback -r ${rootBlankSnapshot}";
          };
        };
      };
    };

    environment = {
      persistence."/persist".files = [ "/etc/zfs/zpool.cache" ];
      systemPackages = [ rootDiffScript ];
    };

    services.zfs = {
      trim.enable = true;
      autoScrub = {
        enable = true;
        pools = [ "rpool" ];
      };
    };

    systemd.services.zfs-mount.enable = false;
  };
}
