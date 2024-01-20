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
      "kwinrc"."Compositing"."LatencyPolicy" = "low";
      "kdeglobals"."KDE"."SingleClick" = "false";
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0;
      "kxkbrc"."Layout" = {
        "DisplayNames" = ",";
        "LayoutList" = "us,ru";
        "Options" = "grp:alt_shift_toggle";
        "ResetOldOptions" = true;
        "Use" = true;
        "VariantList" = ",";
      };
    };
  };
}
