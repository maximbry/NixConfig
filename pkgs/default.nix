{ pkgs ? import <nixpkgs> { } }: rec {
    tg-session-keeper = pkgs.python3Packages.callPackage ./tg-session-keeper { };
    telegram-session-keeper = pkgs.callPackage ./telegram-session-keeper {};
}
