{ pkgs ? import <nixpkgs> { }, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "memavaild";
  version = "v0.5-de0870e";
  src = fetchFromGitHub {
    owner = "hakavlad";
    repo = pname;
    rev = "55352fe";
    sha256 = "sha256-qzEQ8iT4TlOeXv0ihyr7Z+oKfsGXIlkKOURkp9PoYFM=";
  };
  propagatedBuildInputs = with pkgs; [ python3 ];
  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
    "SYSTEMDUNITDIR=${placeholder "out"}/lib/systemd/system"
    "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system"
  ];
  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];
}
