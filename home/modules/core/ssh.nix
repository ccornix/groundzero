{ lib, ... }:

{
  programs = {
    ssh = {
      enable = true;
      matchBlocks."*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
      };
      enableDefaultConfig = false;
    };

    keychain = {
      enable = true;
      keys = lib.mkDefault [ "id_ed25519" ];
    };
  };
}
