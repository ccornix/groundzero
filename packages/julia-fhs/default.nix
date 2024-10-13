# This package is a stripped-down and modified version of olynch's
# scientific-fhs package (without quarto & conda & CUDA)
# https://github.com/olynch/scientific-fhs

{ lib, pkgs, ... }:

let
  # buildFHSUserEnv demands the following to be a function of pkgs

  juliaPackage = pkgs: pkgs.callPackage ./julia.nix { };

  standardPackages = pkgs: with pkgs; [
    autoconf
    binutils
    clang
    cmake
    curl
    expat
    gmp
    gnumake
    gperf
    libxml2
    m4
    nss
    openssl
    stdenv.cc
    unzip
    utillinux
    which
  ];

  graphicalPackages = pkgs: with pkgs; [
    alsaLib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    gettext
    glfw
    glib
    glib.out
    gnome2.GConf
    gtk2
    gtk2-x11
    gtk3
    libGL
    libcap
    libgnome-keyring3
    libgpgerror
    libnotify
    libpng
    libsecret
    libselinux
    libuuid
    ncurses
    nspr
    nss
    pango
    pango.out
    pdf2svg
    qt5.qtbase
    qt5.qtwayland
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libxkbfile
    xorg.xorgproto
    zlib
  ];

  targetPkgs = pkgs: (
    (standardPackages pkgs)
    ++ (graphicalPackages pkgs)
    ++ [ (juliaPackage pkgs) ]
  );

  multiPkgs = pkgs: with pkgs; [ zlib ];

  stdEnvVars = ''
    export EXTRA_CCFLAGS="-I/usr/include"
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
    export LIBARCHIVE=${pkgs.libarchive.lib}/lib/libarchive.so
  '';

  graphicalEnvVars = ''
    export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale
  '';

  profile = stdEnvVars + graphicalEnvVars;

  extraOutputsToInstall = [ "man" "dev" ];

  fhsCommand = commandName: commandScript:
    pkgs.buildFHSUserEnv {
      name = commandName; # Name used to start this UserEnv
      runScript = commandScript;
      inherit targetPkgs multiPkgs extraOutputsToInstall profile;
    };

in
fhsCommand
