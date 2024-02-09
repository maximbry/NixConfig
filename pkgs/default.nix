{ pkgs, ... }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
  uresourced = pkgs.callPackage ./uresourced { };
  nohang = pkgs.callPackage ./nohang { };
  zapret = pkgs.callPackage ./zapret { };
  nekoray = pkgs.callPackage ./nekoray { };
  doom2d-forever = pkgs.callPackage ./doom2d-forever { };
  doom2d-forever-headless = pkgs.callPackage ./doom2d-forever {
    headless = true;
    withOpenAL = false;
    withSDL2_mixer = true;
    withSDL2 = true;
    disableGraphics = true;
    withOpenGL2 = false;
    withHolmes = false;
  };
  zotero-7 = pkgs.callPackage ./zotero-7 { };
  lazarus-git = pkgs.callPackage ./lazarus-git { };
  lazarus-git-gtk2 = pkgs.callPackage ./lazarus-git { };
  lazarus-git-gtk3 = pkgs.callPackage ./lazarus-git { };
  lazarus-git-qt5 = pkgs.callPackage ./lazarus-git { withQt5 = true; };
  lazarus-git-qt6 = pkgs.callPackage ./lazarus-git { };
  libqt5pas-git = pkgs.libsForQt5.callPackage ./libqt5pas-git { };
  doom2d-forever-editor = pkgs.callPackage ./doom2d-forever-editor { };
}
