{ pkgs, lib, stdenv, fetchgit, fetchzip, makeWrapper, makeDesktopItem
, runCommand, copyDesktopItems, unzip, fpc, SDL2, SDL2_mixer, openal, libX11
, enet, libGL, glibc, withHolmes ? true, SDL, SDL_mixer, disableIo ? false, withSDL1 ? false, withSDL2 ? true
, withOpenGL2 ? true, withSDL1_mixer ? false, withSDL2_mixer ? false
, withOpenAL ? true, disableSound ? false, withVorbis ? true, libvorbis, libogg
, libxmp, withLibXmp ? true, libmpg123, withMpg123 ? true, libopus, opusfile
, withOpus ? true }:

let
  optional = lib.optional;
  optionals = lib.optionals;
  version = "0.667";
  bin = "Doom2DF";
  rev = "5a9d04dfb16b32c84964c0940031606e7454259d";
  meta = {
    description = "Doom-themed platformer with network play";
    longDescription = ''
      Doom 2D: Forever is an open source OpenGL side-scrolling shooter for 
      Windows, Android and Linux, a modern port of the 1996 Doom 2D by 
      Prikol Software. It is based upon Doom, and is essentially the 
      original Doom translated into a two-dimensional arcade or console-like
      shooter, comparable to the original Duke Nukem. The game includes
      single player, cooperative, deathmatch, and CTF multiplayer.
    '';
    homepage = "https://www.doom2d.org/";
    license = lib.licenses.gpl3Plus;
    # maintainers = with lib.maintainers; [ chekoopa ];
    platforms = lib.platforms.linux;
  };
  desktopItem = makeDesktopItem rec {
    name = "doom2df";
    exec = "Doom2DF";
    comment = meta.description;
    desktopName = "Doom 2D Forever";
    categories = [ "Game" "Shooter" "ActionGame" ];
    icon = "doom2df";
    startupNotify = false;
    # TODO: fix icons
    # TODO: add next options
    # Version=${version} 
    # Comment=Doom-themed platformer with network play, modern port of the 1996 Doom 2D by Prikol Software
    # Comment[ru]=Платформер с сетевой игрой во вселенной классического Doom, современный порт игры Doom 2D от Prikol Software
    # Keywords=Doom;Doom2D;Doom2D Forever;Forever;Shooter;Doom 2D;
  };
  sdlMixerFlag =
    if ((withSDL2_mixer && withSDL1) || (withSDL1_mixer && withSDL2)) then
      abort "You can't mix different versions of SDL and SDL_Mixer."
    else if (withSDL1_mixer || withSDL2_mixer) then
      "-dUSE_SDLMIXER"
    else
      "";
  
  ioDriver = [
    (if ((withSDL1 && withSDL2) || (withSDL1 && disableIo) || (withSDL2 && disableIo)) then
      abort "You have to choose one system driver (or none)."
    else if (disableIo) then
      "-dUSE_SYSSTUB"
    else if (withSDL1) then
      "-dUSE_SDL"
    else
      "-dUSE_SDL2"
    )
  ];
  soundDriver = [
    (if ((withSDL2_mixer && withOpenAL) || (withSDL2_mixer && disableSound)
      || (withOpenAL && disableSound)) then
      abort "Only one sound driver can be enabled at a time."
    else if disableSound then
      "-dUSE_SOUNDSTUB"
    else if withOpenAL then
      "-dUSE_OPENAL"
    else
      sdlMixerFlag)
  ];

  soundFileDrivers = if (!disableSound) then
    optional withVorbis "-dUSE_VORBIS"
    ++ optional withLibXmp "-dUSE_XMP"
    ++ optional withMpg123 "-dUSE_MPG123"
    ++ optional withOpus "-dUSE_OPUS"
  else
    [ ];

  dflags = soundDriver ++ soundFileDrivers
    ++ ioDriver
    ++ optional withHolmes "-dENABLE_HOLMES"
    ++ optional withOpenGL2 "-dUSE_OPENGL";
  # soundFlags
  doom2df-unwrapped = pkgs.stdenv.mkDerivation rec {
    inherit version;
    pname = "doom2df-unwrapped";
    name = "${pname}-${version}";

    src = fetchgit {
      url = "https://repo.or.cz/d2df-sdl.git";
      inherit rev;
      sha256 = "sha256-lOBDopKffjGPBqF0UA47D9pbX9t5SdrgV95uwDhXrOc=";
    };

    patches = [ ./0001-feat-respect-SOURCE_DATE_EPOCH.patch ];

    env = {
      D2DF_BUILD_USER = "nix";
      D2DF_BUILD_HASH = "${rev}";
    };

    buildInputs = [
      fpc
      enet
    ]
    ++ optional withOpenAL openal
    ++ optional withSDL1 SDL.dev
    ++ optional withSDL1_mixer SDL_mixer
    ++ optional withSDL2 SDL2.dev
    ++ optional withSDL2_mixer SDL2_mixer.dev
    ++ optional withLibXmp libxmp
    ++ optional withMpg123 libmpg123.dev
    ++ optionals withOpus [libopus.dev opusfile.dev]
    ++ optionals withVorbis [libvorbis.dev libogg.dev];

    buildPhase = ''
      cd src/game
      fpc -FE. -FU. -al Doom2DF.lpr ${lib.concatStringsSep " " dflags}
      cd ../..
      cp src/game/${bin} .
    '';

    installPhase = ''
      install -Dm644 ./rpm/res/doom2df.png \
        $out/share/icons/hicolor/256x256/doom2df.png
      install -Dm755 ./${bin} "$out/bin/${bin}"
    '';

    dontPatchELF = true;
    postFixup = ''
      patchelf \
          --add-needed ${glibc}/lib/libpthread.so.0 \
          --add-needed ${SDL2.out}/lib/libSDL2-2.0.so.0 \
          --add-needed ${SDL2_mixer.out}/lib/libSDL2_mixer-2.0.so.0 \
          --add-needed ${openal.out}/lib/libopenal.so.1 \
          --add-needed ${libvorbis.out}/lib/libvorbis.so.0 \
          --add-needed ${libvorbis.out}/lib/libvorbisfile.so.3 \
          --add-needed ${libogg.out}/lib/libogg.so.0 \
          --add-needed ${libxmp.out}/lib/libxmp.so.4 \
          --add-needed ${libmpg123.out}/lib/libmpg123.so.0 \
          --add-needed ${libopus.out}/lib/libopus.so.0 \
          --add-needed ${opusfile.out}/lib/libopusfile.so.0 \
          --add-needed ${enet.out}/lib/libenet.so.7 \
          --add-needed ${glibc}/lib/libdl.so.2 \
          --add-needed ${libX11.out}/lib/libX11.so.6 \
          --add-needed ${glibc}/lib/libc.so.6 \
          --add-needed ${libGL.out}/lib/libGL.so.1 \
          $out/bin/Doom2DF
    '';
  };
  pname = "doom2df";
  name = "doom2df-${version}";
in runCommand name rec {
  inherit doom2df-unwrapped;
  inherit version;
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  desktopItems = [ desktopItem ];
  passthru = {
    inherit version;
    meta = meta // { hydraPlatforms = [ ]; };
  };
} (''
  mkdir -p $out/bin
  ln -s ${doom2df-unwrapped}/bin/${bin} $out/bin/${bin}
  mkdir -p $out/share
  ln -s ${doom2df-unwrapped}/share/icons $out/share/icons
  copyDesktopItems
  wrapProgram $out/bin/${bin} --add-flags "--ro-dir \$HOME/.doom2df"
'')
