{ inputs, config, pkgs, ... }:

let
  inherit (inputs) self;
in
{
  users.users.ccornix = {
    isNormalUser = true;
    uid = 1000;
    hashedPasswordFile = "/persist/secrets/ccornix-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPbbRvx53TLy1P9jnOR1PxmxMUHHsP/hfLuuZHE511G ccornix@b550"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGh1n7HG8vW3W2h5RoqD5KEuWsEzMXz/nKwrPegUccXZ ccornix@b560"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEP1pxfp1gQ4nwlMkDR9hMQqRmD+G9p1lbzPzwLWDlHc ccornix@x13g2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9Kqnlg04ODbr1Je4HogTm+ry8KmesUNtGa+8x2H9fw ccornix@x230"
    ];
    shell = pkgs.bashInteractive;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "dialout" # to access serial ports
    ] ++ self.lib.filterExistingGroups config [
      "networkmanager"
      "scanner"
      "lp"
      "libvirtd"
    ];
  };
}
