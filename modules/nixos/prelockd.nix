{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.prelockd;
in {

  options.services.prelockd = {
    enable = mkEnableOption (lib.mdDoc "prelockd");

    dataDir = mkOption {
      type = types.path;
      description = "";
      default = "/var/lib/prelockd";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.prelockd = {
      description = "prelockd service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "prelockd";
    };
    users.groups.prelockd = { };
    systemd.packages = [ pkgs.prelockd ];
    systemd.services.prelockd.wantedBy = [ "multi-user.target" ];
    environment.etc."prelockd.conf".source = "${pkgs.prelockd}/etc/prelockd.conf";
  };
}
