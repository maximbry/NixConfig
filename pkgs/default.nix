{ pkgs ? import <nixpkgs> { } }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
  uresourced = pkgs.callPackage ./uresourced { };
  zapret = pkgs.callPackage ./zapret { };
  nekoray = pkgs.callPackage ./nekoray { };
  doom2d-forever = pkgs.callPackage ./doom2d-forever { };
}
