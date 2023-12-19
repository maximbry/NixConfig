{ lib, pkgs, ... }: {
  systemd = {
    enableUnifiedCgroupHierarchy = lib.mkForce true;
    enableCgroupAccounting = lib.mkForce true;
  };
}
