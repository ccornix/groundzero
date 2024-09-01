{ appimageTools, devilutionx, fetchurl, stdenv, ... }:

let
  inherit (stdenv.hostPlatform) system;
in
if system == "x86_64-linux" then
  let
    version = "1.5.3";
  in
  appimageTools.wrapType2 {
    name = "devilutionx";
    inherit version;
    src = fetchurl {
      url = "https://github.com/diasurgical/devilutionX/releases/download/${version}/devilutionx-linux-x86_64.appimage";
      sha256 = "sha256-Ta3s+sjMgG1Ebd626m+Ynw7+VXabNJhwmXko8+VE6LQ=";
    };
  }
else
  builtins.trace
    "No appimage for the current system, falling back to nixpkgs devilutionx"
    devilutionx
