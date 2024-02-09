{ stdenv, lib, fetchgit, makeWrapper, writeText, fpc-git, gtk2, glib, pango, atk
, gdk-pixbuf, libXi, xorgproto, libX11, libXext, gdb, gnumake, binutils
, withQt5 ? false, qtbase ? null, libqt5pas-git ? null, wrapQtAppsHook ? null
, withQt6 ? false
, withGtk3 ? false
, withGtk2 ? false
, ...}:

# TODO:
#  1. the build date is embedded in the binary through `$I %DATE%` - we should dump that

let
  version = "3.0.0-0";
  fpc = fpc-git;

  # as of 2.0.10 a suffix is being added. That may or may not disappear and then
  # come back, so just leave this here.
  majorMinorPatch = v:
    builtins.concatStringsSep "." (lib.take 3 (lib.splitVersion v));

  overrides = writeText "revision.inc" (lib.concatStringsSep "\n"
    (lib.mapAttrsToList (k: v: "const ${k} = '${v}';") {
      # this is technically the SVN revision but as we don't have that replace
      # it with the version instead of showing "Unknown"
      RevisionStr = version;
    }));

in stdenv.mkDerivation rec {
  pname = "lazarus-${LCL_PLATFORM}-git-8801ff3";
  inherit version;

  src = fetchgit {
    url = "https://gitlab.com/freepascal.org/lazarus/lazarus.git";
    rev = "8801ff314b0645e7de50db3bf54e09cc5f7e8774";
    sha256 = "sha256-lrEk/Mi87Pr8Zel38oVwEGYxLD3I/YB2qcjR1k5kGdM=";
  };

  postPatch = ''
    cp ${overrides} ide/${overrides.name}
  '';

  buildInputs = [
    # we need gtk2 unconditionally as that is the default target when building applications with lazarus
    fpc
    gtk2
    glib
    libXi
    xorgproto
    libX11
    libXext
    pango
    atk
    stdenv.cc
    gdk-pixbuf
  ] ++ lib.optionals withQt5 [ libqt5pas-git qtbase ];

  # Disable parallel build, errors:
  #  Fatal: (1018) Compilation aborted
  enableParallelBuilding = false;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional withQt5 wrapQtAppsHook;

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "LAZARUS_INSTALL_DIR=${placeholder "out"}/share/lazarus/"
    "INSTALL_PREFIX=${placeholder "out"}/"
    "REQUIRE_PACKAGES+=tachartlazaruspkg"
    "bigide"
  ];

  LCL_PLATFORM = if withQt5 then "qt5" else if withQt6 then "qt6" else if withGtk2 then "gtk2" else "gtk3";

  NIX_LDFLAGS = lib.concatStringsSep " " ([
    "-L${stdenv.cc.cc.lib}/lib"
    "-lX11"
    "-lXext"
    "-lXi"
    "-latk-1.0"
    "-lc"
    "-lcairo"
    "-lgcc_s"
    "-lgdk-x11-2.0"
    "-lgdk_pixbuf-2.0"
    "-lglib-2.0"
    "-lgtk-x11-2.0"
    "-lpango-1.0"
  ] ++ lib.optionals withQt5 [ "-L${lib.getLib libqt5pas-git}/lib" "-lQt5Pas" ]);

  preBuild = ''
    mkdir -p $out/share/fpcsrc "$out/lazarus"
    cp -r ${fpc.src}/* $out/share/fpcsrc
    substituteInPlace ide/packages/ideconfig/include/unix/lazbaseconf.inc \
      --replace '/usr/fpcsrc' "$out/share/fpcsrc"
  '';

  postInstall =
    let ldFlags = ''$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')'';
    in ''
      wrapProgram $out/bin/startlazarus \
        --prefix NIX_LDFLAGS ' ' "${ldFlags}" \
        --prefix NIX_LDFLAGS_${binutils.suffixSalt} ' ' "${ldFlags}" \
        --prefix LCL_PLATFORM ' ' "$LCL_PLATFORM" \
        --prefix PATH ':' "${lib.makeBinPath [ fpc gdb gnumake binutils ]}"
    '';

  meta = with lib; {
    description = "Graphical IDE for the FreePascal language";
    homepage = "https://www.lazarus.freepascal.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
