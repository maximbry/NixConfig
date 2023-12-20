{ pkgs ? import <nixpkgs> { } }: rec {
  prelockd = pkgs.callPackage ./prelockd { };
  memavaild = pkgs.callPackage ./memavaild { };
}
