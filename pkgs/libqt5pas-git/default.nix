{ mkDerivation, lib, lazarus-git, qtbase, qtx11extras, qmake, breakpointHook
  , ... }:

mkDerivation rec {
  pname = "libqt5pas";
  inherit (lazarus-git) version src;

  sourceRoot = "${src.name}/lcl/interfaces/qt5/cbindings";

  postPatch = ''
    substituteInPlace Qt5Pas.pro \
      --replace 'target.path = $$[QT_INSTALL_LIBS]' "target.path = $out/lib"
  '';

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtx11extras ];

  meta = with lib; {
    description = "Free Pascal Qt5 binding library";
    homepage = "https://wiki.freepascal.org/Qt5_Interface#libqt5pas";
    maintainers = with maintainers; [ sikmir ];
    inherit (lazarus-git.meta) license platforms;
  };
}