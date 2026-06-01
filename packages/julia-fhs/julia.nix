{ stdenv
, lib
, fetchurl
, zlib
, glib
, dbus
, fontconfig
, freetype
, libGL
, libxi
, libxcb
, libxrender
, libx11
, libsm
, libice
, libxext
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
    libxi
    libxcb
    libxrender
    libx11
    libsm
    libice
    libxext
    dbus
    fontconfig
    freetype
    libGL
  ];
}
