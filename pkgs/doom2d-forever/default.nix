{ pkgs, lib, stdenv, fetchgit, makeWrapper, makeDesktopItem, runCommand, copyDesktopItems, autoPatchelfHook,
  fpc, enet, libX11, glibc,
  targetProcessor ? "ATHLON64",
  sseSupport ? ["SSE64"],
  headless ? false,
  withHolmes ? true,
  disableIo ? false,
  withSDL1 ? false, SDL,
  withSDL2 ? true, SDL2,
  disableGraphics ? false, libGL,
  withOpenGLES ? false,
  withOpenGL2 ? true,
  disableSound ? false,
  withSDL1_mixer ? false, SDL_mixer,
  withSDL2_mixer ? false, SDL2_mixer,
  withOpenAL ? true, openal,
  withVorbis ? true, libvorbis, libogg,
  withLibXmp ? true, libxmp,
  withMpg123 ? true, libmpg123,
  withOpus ? true, libopus, opusfile,
  withMiniupnpc ? true, miniupnpc,
  ...
}:

let
  optional = lib.optional;
  optionals = lib.optionals;
  version = "0.667";
  bin = "Doom2DF";
  finalBin = if headless then "Doom2DF_H" else "Doom2DF";
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
      abort "Exactly one system driver should be enabled (or none)."
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
      abort "Exactly one sound driver should be enabled (or none)."
    else if disableSound then
      "-dUSE_SOUNDSTUB"
    else if withOpenAL then
      "-dUSE_OPENAL"
    else
      sdlMixerFlag)
  ];
  renderDriver = [
    (
      if ((!withOpenGL2 && !disableGraphics && !withOpenGLES) || (withOpenGL2 && withOpenGLES) || (withOpenGL2 && disableGraphics) || (withOpenGLES && disableGraphics)) then
        abort "Exactly one render driver should be enabled (or none)."
      else if (!withOpenGL2 && withHolmes) then
        abort "Holmes is supported only with desktop OpenGL."
      else if disableGraphics then
        "-dUSE_GLSTUB"
      else if withOpenGLES then
        "-dUSE_GLES1"
      else
        "-dUSE_OPENGL"
    )
  ];

  soundFileDrivers = if (!disableSound) then
    optional withVorbis "-dUSE_VORBIS"
    ++ optional withLibXmp "-dUSE_XMP"
    ++ optional withMpg123 "-dUSE_MPG123"
    ++ optional withOpus "-dUSE_OPUS"
  else
    [ ];
  
  miscFlags = optional withHolmes "-dENABLE_HOLMES"
              ++ optional headless "-dHEADLESS"
              ++ optional withMiniupnpc "-dUSE_MINIUPNPC";
  
  optimizationFlags = ["-Op${targetProcessor}" "-Cp${targetProcessor}"] ++ (map (x: "-Cf" + x) sseSupport);

  dflags = soundDriver ++ soundFileDrivers
    ++ ioDriver
    ++ renderDriver
    ++ miscFlags
    ++ optimizationFlags;

  doom2df-unwrapped = pkgs.stdenv.mkDerivation rec {
    inherit version;
    pname = "doom2df-unwrapped";
    name = "${pname}-${version}";

    src = fetchgit {
      url = "https://repo.or.cz/d2df-sdl.git";
      inherit rev;
      sha256 = "sha256-lOBDopKffjGPBqF0UA47D9pbX9t5SdrgV95uwDhXrOc=";
    };

    patches = [ ./0001-feat-respect-SOURCE_DATE_EPOCH.patch ./0001-fix-Fix-compilation-on-FPC-3.3.1.patch ];

    env = {
      D2DF_BUILD_USER = "nix";
      D2DF_BUILD_HASH = "${rev}";
    };

    nativeBuildInputs = [
      autoPatchelfHook
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
    ++ optionals withVorbis [libvorbis.dev libogg.dev]
    ++ optional withMiniupnpc miniupnpc;

    buildInputs = [
      glibc
    ]
    ++ optionals (!disableGraphics) [libGL libX11]
    ++ optional withSDL1 SDL
    ++ optional withSDL1_mixer SDL_mixer
    ++ optional withSDL2 SDL2
    ++ optional withSDL2_mixer SDL2_mixer
    ++ optional withOpenAL openal
    ++ optional (!disableSound && withLibXmp) libxmp
    ++ optional (!disableSound && withMpg123) libmpg123
    ++ optionals (!disableSound && withOpus) [libopus opusfile]
    ++ optionals (!disableSound && withVorbis) [libvorbis libogg]
    ++ optional withMiniupnpc miniupnpc;

    buildPhase = ''
      cd src/game
      fpc -al Doom2DF.lpr -FE. -FU. ${lib.concatStringsSep " " dflags}
      cd ../..
      cp src/game/${bin} .
    '';

    installPhase = ''
      install -Dm644 ./rpm/res/doom2df.png \
        $out/share/icons/hicolor/256x256/doom2df.png
      install -Dm755 ./${bin} "$out/bin/${bin}"
    '';

    postFixup = if (!disableGraphics) then ''
      patchelf \
          --add-needed ${libGL.out}/lib/libGL.so.1 \
          $out/bin/Doom2DF
    '' else "";

  };
  pname = "doom2df";
  name = "doom2df-${version}-${if headless then "headless" else "desktop"}";
in runCommand name rec {
  inherit doom2df-unwrapped;
  inherit version name pname;
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  desktopItems = [ desktopItem ];
  passthru = {
    inherit version;
    meta = meta // { hydraPlatforms = [ ]; };
  };
  platforms = [ "x86_64-linux" ];
  outputs = ["out"];
} (''
  mkdir -p $out/bin
  ln -s ${doom2df-unwrapped}/bin/${bin} $out/bin/${finalBin}
  mkdir -p $out/share
  ln -s ${doom2df-unwrapped}/share/icons $out/share/icons
  copyDesktopItems
  wrapProgram $out/bin/${finalBin} --add-flags "--ro-dir \$HOME/.doom2df"
'')
