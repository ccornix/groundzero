{ ... }:

{
  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
      # FIXME: switch later to this new option
      # addKeysToAgent = "yes";
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
    };
  };
}
