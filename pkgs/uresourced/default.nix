{ pkgs ? import <nixpkgs> { }, lib, fetchgit, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "uresourced";
  version = "0.5.3-af9cac5b";
  src = fetchgit {
    url = "https://gitlab.freedesktop.org/benzea/uresourced.git";
    rev = "af9cac5b78507c58f72ab6e389583755f50cdc5f";
    sha256 = "sha256-CXb+c0Yt9O8081mVNOSpaHU6ctB/C598ZDyLntkk66c=";
  };

  nativeBuildInputs = with pkgs; [ meson pkg-config cmake ninja ];
  buildInputs = with pkgs; [ glib systemd pipewire ];
  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dappmanagement=true"
  ];
}
