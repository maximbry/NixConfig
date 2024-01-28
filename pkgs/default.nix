{ pkgs ? import <nixpkgs> { } }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
  uresourced = pkgs.callPackage ./uresourced { };
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
  zotero-7 = pkgs.callPackage ./zotero-7 {};
}
