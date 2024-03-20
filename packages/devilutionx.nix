{ appimageTools, devilutionx, fetchurl, stdenv, ... }:

let
  inherit (stdenv.hostPlatform) system;
in
if system == "x86_64-linux" then
  let
    name = "devilutionx";
    version = "1.5.2";
  in
  appimageTools.wrapType2 {
    inherit name version;
    src = fetchurl {
      url = "https://github.com/diasurgical/devilutionX/releases/download/${version}/devilutionx-linux-x86_64.appimage";
      sha256 = "sha256-cX5X3URheW+exdrH/TPvRRW71B3EGJ63j0z0LitHoEg=";
    };
  }
else
  devilutionx # Fallback
