{ config, ... }: {
  imports = [
    ./threadirqs.nix
    ./dirty-bytes.nix
    ./disable-icmp.nix
    ./disable-mitigations.nix
    ./disable-watchdog.nix
    ./ecn.nix
    ./good-response-time.nix
    ./iomem.nix
    ./iommu.nix
    ./elevator-none.nix
    ./pstate.nix
    ./split-lock.nix
  ];
}
