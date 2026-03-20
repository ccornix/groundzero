{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  libGL,
  libx11,
  libxxf86dga,
  alsa-lib,
  libxrandr,
  libxxf86vm,
  libxext,
  SDL2,
  glibc,
  vulkan-loader,
}:
let
  arch = if stdenv.hostPlatform.isx86_64 then "x64" else stdenv.hostPlatform.parsed.cpu.name;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "Quake3e";
  version = "2025-10-14";

  src = fetchFromGitHub {
    owner = "ec-";
    repo = "Quake3e";
    tag = finalAttrs.version;
    sha256 = "sha256-3Ij0GEPXdl7Lhp9o1Zdwg1tcLgFEay686QjhSlh8iAo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    curl
    libGL
    libx11
    libxxf86dga
    alsa-lib
    libxrandr
    libxxf86vm
    libxext
    SDL2
    glibc
    vulkan-loader
  ];
  env.NIX_CFLAGS_COMPILE = "-I${lib.getInclude SDL2}/include/SDL2";
  enableParallelBuilding = true;

  postPatch = ''
    sed -i -e 's#OpenGLLib = dlopen( dllname#OpenGLLib = dlopen( "${libGL}/lib/libGL.so"#' code/unix/linux_qgl.c
    sed -i -e 's#Sys_LoadLibrary( "libpthread.so.0" )#Sys_LoadLibrary( "${glibc}/lib/libpthread.so.0" )#' code/unix/linux_snd.c
    sed -i -e 's#Sys_LoadLibrary( "libasound.so.2" )#Sys_LoadLibrary( "${alsa-lib}/lib/libasound.so.2" )#' code/unix/linux_snd.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86dga.so.1" )#Sys_LoadLibrary( "${libxxf86dga}/lib/libXxf86dga.so.1" )#' code/unix/x11_dga.c
    sed -i -e 's#Sys_LoadLibrary( "libXrandr.so.2" )#Sys_LoadLibrary( "${libxrandr}/lib/libXrandr.so.2" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86vm.so.1" )#Sys_LoadLibrary( "${libxxf86vm}/lib/libXxf86vm.so.1" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86vm.so.1" )#Sys_LoadLibrary( "${libxxf86vm}/lib/libXxf86vm.so.1" )#' code/unix/x11_vidmode.c
    sed -i -e 's#"libcurl.so.4"#"${curl.out}/lib/libcurl.so.4"#' code/client/cl_curl.h
    sed -i -e 's#"libvulkan.so.1"#"${vulkan-loader}/lib/libvulkan.so.1"#' code/unix/linux_qvk.c
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR=$out/lib
    makeWrapper $out/lib/quake3e.${arch} $out/bin/quake3e
    makeWrapper $out/lib/quake3e.ded.${arch} $out/bin/quake3e.ded
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ec-/Quake3e";
    description = "Improved Quake III Arena engine";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
