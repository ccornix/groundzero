{
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (inputs) self;
in
{
  users.users.ccornix = {
    isNormalUser = true;
    uid = 1000;
    hashedPasswordFile = "/persist/secrets/ccornix-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ39eOgs8/6txBKw2fiSOzgBWenb0TZoisSfVxofSd3d ccornix@b550m"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEP1pxfp1gQ4nwlMkDR9hMQqRmD+G9p1lbzPzwLWDlHc ccornix@x13g2"
    ];
    shell = pkgs.bashInteractive;
    extraGroups =
      [
        "wheel"
        "audio"
        "video"
        "input"
        "i2c" # to control monitor brightness via DDC
        "dialout" # to access serial ports
      ]
      ++ self.lib.filterExistingGroups config [
        "networkmanager"
        "scanner"
        "lp"
        "libvirtd"
      ];
  };
}
