{ pkgs, ... }: {
  systemd = {
    oomd = {
      enableRootSlice = true;
      enableUserServices = true;
    };
  };
}
