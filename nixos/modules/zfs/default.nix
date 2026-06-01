{ config, lib, pkgs, ... }:

let
  cfg = config.my.zfs;

  rootPoolName = "rpool";
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
    # boot.initrd.postResumeCommands = lib.mkAfter ''
    #   zfs rollback -r ${rootBlankSnapshot}
    # '';
    boot.initrd.systemd.services.rollback = {
      description = "Rollback root ZFS dataset to blank snapshot";

      wantedBy = [ "initrd.target" ];

      # Must run after the ZFS pool is imported...
      after = [
        "zfs-import-${rootPoolName}.service"
      ];

      # ...but before the root dataset is mounted
      before = [ "sysroot.mount" ];

      path = [ pkgs.zfs ];

      unitConfig.DefaultDependencies = "no";

      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal+console";
        StandardError  = "journal+console";
      };

      script = ''
        zfs rollback -r ${rootBlankSnapshot}
      '';
    };

    boot = {
      kernelParams = [
        "nohibernate"
        # WORKAROUND: get rid of error
        # https://github.com/NixOS/nixpkgs/issues/35681
        "systemd.gpt_auto=0"
      ] ++ lib.optional (cfg.arcMaxMiB > 0)
        "zfs.zfs_arc_max=${toString (cfg.arcMaxMiB * 1048576)}";

      supportedFilesystems = [ "zfs" ];

      zfs.forceImportRoot = false;
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
