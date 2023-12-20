{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) attrsOf coercedTo listOf oneOf str int bool;
  cfg = config.services.memavaild;
in {

  options.services.memavaild = {
    enable = mkEnableOption (lib.mdDoc "memavaild");
  };

  config = lib.mkIf cfg.enable {
    users.users.memavaild = {
      description = "memavaild service user";
      createHome = false;
      isSystemUser = true;
      group = "memavaild";
    };
    users.groups.memavaild = { };
    systemd.packages = [ pkgs.memavaild ];
    systemd.services.memavaild.wantedBy = [ "multi-user.target" ];
    environment.etc."memavaild.conf".source = "${pkgs.memavaild}/etc/memavaild.conf";
  };
}
