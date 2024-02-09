{ pkgs, lib, fetchgit, autoPatchelfHook, fpc-git, libX11
, withGtk2 ? false, lazarus-git
, withQt5 ? true, lazarus-git-qt5, qtbase ? null, libqt5pas-git ? null, wrapQtAppsHook ? null
, withQt6 ? false, lazarus-git-qt6
, withGtk3 ? false, lazarus-git-gtk3
, ... }:
let
  fpc = fpc-git;
  lazarus = if withGtk2 then lazarus-git else if withGtk3 then lazarus-git-gtk3 else if withQt5 then lazarus-git-qt5 else lazarus-git-qt6;
  libqt5pas = libqt5pas-git;
  rev = "a1e98e052e6d8dbf38d45d9ef7338bfd758b9f48";
in pkgs.stdenv.mkDerivation rec {
  pname = "doom2d-forever-editor";
  version = "v0.667-git-a1e98e0";
  src = fetchgit {
    url = "https://repo.or.cz/d2df-editor.git";
    inherit rev;
    sha256 = "sha256-JTBYHfZk6Qgjdmr5Nb7n6juMLjhmgFTe1xIrzgg1JYY=";
  };
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    lazarus
    gtk2
    glibc
    libGL
    libX11
    fpc
    pango
    cairo
    gdk-pixbuf
    gcc
  ]
  ++ lib.optionals withQt5 [ libqt5pas qtbase ];
  buildInputs = with pkgs; [ gtk2 glibc libGL libX11 pango cairo gdk-pixbuf ];

  patches = [ ./0001-Temporary-patch-to-allow-building-on-fpc-git.patch ];

  NIX_LDFLAGS = lib.concatStringsSep " " ([
    "--as-needed -rpath ${lib.makeLibraryPath buildInputs}"
  ] ++ lib.optionals withQt5 [ "-L${lib.getLib libqt5pas}/lib" "-lQt5Pas" ]);

  env = {
    D2DF_BUILD_USER = "nixbld";
    D2DF_BUILD_HASH = "${rev}";
  };
  enableParallelBuilding = false;
  buildPhase = ''
    runHook preInstall
    cd src/editor
    cat << EOF > nosched.c
    #define _GNU_SOURCE
    #include <dlfcn.h>
    #include <pthread.h>
    #include <stdio.h>
    #include <string.h>

    int pthread_noop() {
      fprintf(stderr, "%s(...)\n", __func__);
      return 0;
    }

    // https://stackoverflow.com/questions/15599026/how-can-i-intercept-dlsym-calls-using-ld-preload/18825060#18825060

    static void* (*libc_dlvsym)(void*, const char*) = NULL;
    static void* (*libc_dlsym)(void*, const char*) = NULL;

    void* dlsym(void* handle, const char* symbol) {

      if (!libc_dlsym) {
        libc_dlsym = dlvsym(RTLD_NEXT, "dlsym", "GLIBC_2.2.5");
      }

      //~ fprintf(stderr, "%s(_, %s)\n", __func__, symbol);

      if (strcmp(symbol, "pthread_attr_setinheritsched") == 0) {
        return pthread_noop;
      }

      return libc_dlsym(handle, symbol);
    }
    EOF
    gcc -shared nosched.c -ldl -o nosched.so
    chmod +x nosched.so
    INSTANTFPCCACHE=./lazarus LD_PRELOAD=$PWD/nosched.so lazbuild --ws=${if withQt6 then "qt6" else if withQt5 then "qt5" else if withGtk3 then "gtk3" else "gtk2"} --lazarusdir=${lazarus}/share/lazarus --pcp=./lazarus --bm=Release Editor.lpi
    runHook postInstall
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $NIX_BUILD_TOP/${src.name}/bin/editor $out/bin/editor
  '';
}
