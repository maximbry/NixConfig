# This file defines overlays
{ inputs, ... }: {
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (_: flake:
      let
        legacyPackages = ((flake.legacyPackages or { }).${final.system} or { });
        packages = ((flake.packages or { }).${final.system} or { });
      in if legacyPackages != { } then legacyPackages else packages) inputs;
  };

  additions = final: _prev: import ../pkgs { pkgs = final; };
  modifications = final: prev: {
    doom2d-forever = prev.doom2d-forever.override {
      fpc = final.fpc-git;
      targetProcessorSoft = "X86-64-V3";
      targetProcessorHard = "COREAVX2";
      sseSupport = [ "X86-64-V3" ];
      optimizationLevel = 4;
      doWholeProgramOptimization = true;
    };
    doom2d-forever-headless = prev.doom2d-forever-headless.override {
      fpc = final.fpc-git;
      targetProcessorSoft = "X86-64-V3";
      targetProcessorHard = "COREAVX2";
      sseSupport = [ "X86-64-V3" ];
      optimizationLevel = 4;
      doWholeProgramOptimization = true;
    };
    fpc-git = prev.fpc.overrideAttrs (oldAttrs: {
      src = final.fetchgit {
        url = "https://gitlab.com/freepascal.org/fpc/source.git";
        rev = "46508f6af16b7f676ca05bc9f84f904d3c2aac23";
        sha256 = "sha256-0HjI4FXWXA8P468dK7GLSofgDdPfCSvyohJlIbS/KSc=";
      };
      patches = [ ./0001-Mark-paths-for-NixOS.patch ];

      postPatch = ''
        # substitute the markers set by the mark-paths patch
        substituteInPlace compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${final.glibc}"
        substituteInPlace compiler/systems/t_linux.pas --subst-var-by syslibpath "${final.glibc}/lib"
        # Replace the `codesign --remove-signature` command with a custom script, since `codesign` is not available
        # in nixpkgs
        # Remove the -no_uuid strip flag which does not work on llvm-strip, only
        # Apple strip.
        substituteInPlace compiler/Makefile \
          --replace \
            "\$(CODESIGN) --remove-signature" \
            "${prev.fpc}/remove-signature.sh}" \
          --replace "ifneq (\$(CODESIGN),)" "ifeq (\$(OS_TARGET), darwin)" \
          --replace "-no_uuid" ""
      '';
    });
  };
}
