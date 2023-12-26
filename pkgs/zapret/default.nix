{ pkgs, stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
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
    mkdir -p ${placeholder "out"}/lib/systemd/system ${placeholder "out"}/bin
    cp Makefile ${placeholder "out"}/
    for g in {nfq,tpws,ip2net,ipset,init.d,common}; do
      cp -R $g ${placeholder "out"}/
    done
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "TGT := binaries/my" "TGT := ${placeholder "out"}/bin"
    substituteInPlace ${placeholder "out"}/Makefile \
      --replace "DIRS := nfq tpws ip2net mdig" "DIRS := nfq tpws ip2net"
    substituteInPlace ${
      placeholder "out"
    }/init.d/systemd/zapret-list-update.service \
      --replace "ExecStart=/opt/zapret" "ExecStart=${placeholder "out"}"
    substituteInPlace ${placeholder "out"}/init.d/systemd/zapret.service \
      --replace "ExecStart=/opt/zapret" "ExecStart=${placeholder "out"}"

    make all -C ${placeholder "out"}/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r ${placeholder "out"}/init.d/systemd/* ${
      placeholder "out"
    }/lib/systemd/system
    runHook postInstall
  '';
}
