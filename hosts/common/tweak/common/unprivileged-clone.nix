{ config, ... }: {
  boot = {
    kernel = {
      sysctl = {
        "kernel.unprivileged_userns_clone" = 1;
      };
    };
  };
}
