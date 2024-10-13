{ stdenv
, lib
, fetchurl
, zlib
, glib
, xorg
, dbus
, fontconfig
, freetype
, libGL
}:

let
  # When bumping version and Julia is not installed, run
  #     nix build .#julia-fhs
  # to obtain the new sha256 hash, contained in the error message
  version = "1.11.0";
  sha256 = "sha256-vPgVVT/aLteRBSTIyqGJyOgZGkCnmd2LX77Q2d1riCw=";
in stdenv.mkDerivation {
  name = "julia-${version}";
  src = fetchurl {
    url = "https://julialang-s3.julialang.org/bin/linux/x64/${
        lib.versions.majorMinor version
      }/julia-${version}-linux-x86_64.tar.gz";
    inherit sha256;
  };
  installPhase = ''
    mkdir $out
    cp -R * $out/
  '';
  dontStrip = true;
  ldLibraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    zlib
    glib
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libXext
    dbus
    fontconfig
    freetype
    libGL
  ];
}
