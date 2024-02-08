{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.gamescope;

  lazarus =
    pkgs.runCommand "lazbuild" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${cfg.package}/bin/lazbuild
    '';
in
{
  options.programs.gamescope = {
    enable = mkEnableOption (mdDoc "lazarus");

    package = mkPackageOption pkgs "lazarus" { };

    capSysNice = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc ''
      '';
    };

  };

  config = mkIf cfg.enable {
    security.wrappers = mkIf cfg.capSysNice {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${lazarus}/bin/lazbuild";
        capabilities = "cap_sys_nice+pie";
      };
    };

    environment.systemPackages = mkIf (!cfg.capSysNice) [ gamescope ];
  };
}
