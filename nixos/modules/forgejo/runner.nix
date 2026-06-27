{ pkgs, config, lib, ... }:

let
  cfg = config.my.forgejo.runner;
  uid = 1024;
  uidStr = builtins.toString uid;

  # Rootless podman API socket, owned by the runner user. Job containers run
  # inside the runner user's UID namespace rather than as root.
  dockerHost = "unix:///run/user/${uidStr}/podman/podman.sock";
in
{
  options.my.forgejo.runner = {
    enable = lib.mkEnableOption "Forgejo Actions runner";

    connectionFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/gitea-runner/connection.yaml";
      description = ''
        Path to the runner's connection configuration, read by the daemon at
        start. It holds the per-runner identity (Forgejo instance URL, UUID and
        token) and is deliberately kept out of the Nix store, so the token never
        enters the world-readable store.

        Recent Forgejo dropped the legacy shared "registration token" flow (the
        deprecated `forgejo-runner register` step) in favour of per-runner
        connection credentials. Create a runner at
        <instance>/user/settings/actions/runners and copy the YAML it shows
        (once!) into this file, readable only by the runner user, e.g.:

          sudo -u gitea-runner tee /var/lib/gitea-runner/connection.yaml >/dev/null <<'EOF'
          server:
            connections:
              forgejo:
                url: https://codefloe.com/
                uuid: <uuid>
                token: <token>
          EOF
          sudo chmod 600 /var/lib/gitea-runner/connection.yaml

        If the runner is deleted and re-created, refresh this file with the new
        UUID + token; nothing in Nix needs to change.
      '';
    };

    labels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "docker:docker://node:lts-trixie-slim" ];
      example = [ "node-lts:docker://node:lts-trixie-slim" "host:host" ];
      description = ''
        Runner labels in `<name>:<executor>` form, where `<name>` is what
        workflows match in `runs-on:` and `<executor>` is e.g.
        `docker://<image>` (run jobs in that container image) or `host`. The
        `docker://` prefix is required for containerised execution; a bare image
        name would be parsed as an invalid executor.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ podman-compose ];

    environment.persistence."/persist" = {
      directories = [
        {
          directory = "/var/lib/gitea-runner";
          user = "gitea-runner";
          group = "gitea-runner";
          mode = "u=rwx,g=,o=";
        }
      ];
    };

    # No rootful daemon socket and no `docker` shim: the runner talks to the
    # per-user rootless podman API socket instead (see dockerHost above).
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # Dedicated unprivileged user that owns the rootless podman engine and runs
    # the Forgejo runner. A fixed uid is required so we can address its runtime
    # dir (/run/user/<uid>) deterministically.
    users.groups.gitea-runner = { };
    users.users.gitea-runner = {
      isNormalUser = true;
      inherit uid;
      group = "gitea-runner";
      home = "/var/lib/gitea-runner";
      autoSubUidGidRange = true; # /etc/subuid + /etc/subgid for rootless maps
      # Start its user systemd session at boot, so /run/user/<uid> +
      # podman.socket exist with nobody logged in.
      linger = true;
    };

    # Expose the rootless podman API socket in user sessions
    # (/run/user/<uid>/podman/podman.sock). With linger above, the runner user's
    # socket is listening from boot.
    systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

    # Drive the daemon directly with the connection file. The legacy
    # `services.gitea-actions-runner` module is built around the deprecated
    # `register` flow and is intentionally not used.
    systemd.services.forgejo-runner = {
      description = "Forgejo Actions Runner";
      after = [ "network-online.target" "user@${uidStr}.service" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        XDG_RUNTIME_DIR = "/run/user/${uidStr}";
        DOCKER_HOST = dockerHost;
      };

      serviceConfig = {
        User = "gitea-runner";
        Group = "gitea-runner";
        StateDirectory = "gitea-runner"; # /var/lib/gitea-runner
        WorkingDirectory = "/var/lib/gitea-runner";
        ExecStart = lib.concatStringsSep " " ([
          "${pkgs.forgejo-runner}/bin/forgejo-runner daemon"
          "--config ${cfg.connectionFile}"
        ] ++ map (label: "--label ${label}") cfg.labels);
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
