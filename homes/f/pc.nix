{ inputs, outputs, pkgs, lib, ... }: {
  imports = [
    ./global

    ./features/basic
    ./features/desktop/common
    ./features/compression
    ./features/image_optimization
    ./features/dns
    ./features/net
    ./features/secrets_management
    ./features/hardware_monitor
    ./features/vscode
    ./features/dev
    ./features/shell

    ./features/pc
  ];

  programs.plasma = {
    enable = true;

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
    };


  };
}
