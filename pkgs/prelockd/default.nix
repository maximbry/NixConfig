{ pkgs ? import <nixpkgs> { }, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "prelockd";
  version = "v0.9-de0870e";
  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = pname;
    rev = "de0870e";
    sha256 = "sha256-NlDXECD1PPVLXWuhyEEoZH2GOSIKh8feXqPbn89A62o=";
  };
  propagatedBuildInputs = with pkgs; [ python3 ];
  makeFlags = [ "DESTDIR=${placeholder "out"}" ''PREFIX=""'' ];
}
