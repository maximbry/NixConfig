{ pkgs ? import <nixpkgs> { }, lib, fetchFromGitHub, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "zapret";
  version = "git-3f80ae2";
  src = fetchFromGitHub {
    owner = "bol-van";
    repo = pname;
    rev = "3f80ae2dd7b972942db7a7983bab2ece2957f7bf";
    sha256 = "sha256-vKs2geD+eKs4hbvPjrLQhCkKWgVVvn31R8KWWe7VZ4k=";
  };

  propagatedBuildInputs = with pkgs; [
    libcap
    zlib
    libnetfilter_queue
    libnfnetlink
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p ${placeholder "out"}
    cp Makefile ${placeholder "out"}/
    for g in {nfq,tpws,ip2net,init.d,common}; do
      cp -R $g ${placeholder "out"}/
    done
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "TGT := binaries/my" "TGT := ${placeholder "out"}/bin"
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "DIRS := nfq tpws ip2net mdig" "DIRS := nfq tpws ip2net"
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "mv" "#mv"
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "ln" "true ; \ #ln"
    make all -C ${placeholder "out"}/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv ${placeholder "out"}/nfq/nfqws ${placeholder "out"}/bin/
    for g in {tpws,ip2net}; do
      mv ${placeholder "out"}/$g/$g ${placeholder "out"}/bin/
    done
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "ln" "true ; \ #ln"
    runHook postInstall
  '';
}
