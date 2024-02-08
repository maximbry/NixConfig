{ pkgs, lib, fetchgit, lazarus-git, autoPatchelfHook, libX11, fpc-git, fakeroot
, ... }:
let fpc = fpc-git;
in pkgs.stdenv.mkDerivation rec {
  pname = "doom2d-forever-editor";
  version = "v0.667-git-a1e98e0";
  src = fetchgit {
    url = "https://repo.or.cz/d2df-editor.git";
    rev = "a1e98e052e6d8dbf38d45d9ef7338bfd758b9f48";
    sha256 = "sha256-JTBYHfZk6Qgjdmr5Nb7n6juMLjhmgFTe1xIrzgg1JYY=";
  };
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    lazarus-git
    gtk2
    glibc
    libGL
    libX11
    fpc
    pango
    cairo
    gdk-pixbuf
    fakeroot
    fakechroot
    coreutils
    util-linux
    gdb
#    breakpointHook
  ];
  buildInputs = with pkgs; [
    gtk2
    glibc
    libGL
    libX11
    pango
    cairo
    gdk-pixbuf
    fakeroot
    fakechroot
    coreutils
    util-linux
    gdb
  ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";
  enableParallelBuilding = false;
  buildPhase = ''
    runHook preInstall
    cd src/editor
    lazbuild --lazarusdir=${lazarus-git}/share/lazarus --pcp=./lazarus --bm=Debug Editor.lpi
    runHook postInstall
  '';
}
