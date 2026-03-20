{ appimageTools, devilutionx, fetchurl, stdenv, ... }:

let
  inherit (stdenv.hostPlatform) system;
in
if system == "x86_64-linux" then
  let
    version = "1.5.5";
  in
  appimageTools.wrapType2 {
    pname = "devilutionx";
    inherit version;
    src = fetchurl {
      url = "https://github.com/diasurgical/devilutionX/releases/download/${version}/devilutionx-linux-x86_64.appimage";
      sha256 = "sha256-OKiLPh8SfshDaUmhdmk3g4umWWoVaGdzxpx+BIKBbGE=";
    };
  }
else
  builtins.trace
    "No appimage for the current system, falling back to nixpkgs devilutionx"
    devilutionx
