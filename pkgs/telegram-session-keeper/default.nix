{ pkgs ? import <nixpkgs> { }, fetchFromGitHub, lib }:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "telegram-session-keeper";
  version = "0.1";
  cargoLock.lockFile = "${src}/Cargo.lock";
  src = fetchFromGitHub {
    owner = "xJonathanLEI";
    repo = "telegram-session-keeper";
    rev = "2c696f5";
    sha256 = "sha256-Wq4vg4z36KB0VcGLXFjkg/VSLhEsiz/onkqdaJrC7Z8=";
  };
}
