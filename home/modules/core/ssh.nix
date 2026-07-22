{ lib, ... }:

{
  programs = {
    ssh = {
      enable = true;
      settings."*" = {
        ForwardAgent = true;
        AddKeysToAgent = "yes";
        ForwardX11 = "yes";
        ForwardX11Trusted = "yes";
      };
      enableDefaultConfig = false;
    };

    keychain = {
      enable = true;
      keys = lib.mkDefault [ "id_ed25519" ];
    };
  };
}
