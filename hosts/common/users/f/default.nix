{ pkgs, inputs, config, ... }:
let
  ifTheyExist = groups:
    builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users.mutableUsers = false;
  users.users.f = {
    isNormalUser = true;

    extraGroups = [ "wheel" "video" "audio" ] ++ ifTheyExist [
      "minecraft"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
      "networkmanager"
      "adbusers"
      "lxd"
      "vboxusers"
      "uucp"

      "cdrom"
      "tape"
      "input"
      "games"
      "floppy"
      "render"
      "realtime"
      "dialout"
      "network"
      "flashrom"
    ];

    initialPassword = "test";
    packages = [ pkgs.home-manager ];
  };

  fileSystems = {
    "/home/f" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=100%" ];
    };
  };

  programs.fuse.userAllowOther = true;

  home-manager = {
    users = {
      f = import ../../../../homes/f/${config.networking.hostName}.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  systemd.tmpfiles = {
    rules = [
      "d /persist/home/f/ 0750 f users -"
      "d /persist/home/f/Downloads 0750 f users -"
      "d /persist/home/f/Music 0750 f users -"
      "d /persist/home/f/Pictures 0750 f users -"
      "d /persist/home/f/Documents 0750 f users -"
      "d /persist/home/f/Videos 0750 f users -"
      ''d "/persist/home/f/VirtualBox VMs" 0750 f users -''
      "d /persist/home/f/VM 0750 f users -"
      "d /persist/home/f/Templates 0750 f users -"
      "d /persist/home/f/Public 0750 f users -"
      "d /persist/home/f/Desktop 0750 f users -"
      "d /persist/home/f/NixConfig 0750 f users -"
      "d /persist/home/f/.local 0750 f users -"
      "d /persist/home/f/.config 0750 f users -"
      "d /persist/home/f/.gnupg 0750 f users -"
      "d /persist/home/f/.ssh 0750 f users -"
      "d /persist/home/f/.nixops 0750 f users -"
      "d /persist/home/f/.vscode 0750 f users -"
      "d /persist/home/f/.vscode-insiders 0750 f users -"
      "d /persist/home/f/.vscodium 0750 f users -"

      "d /persist/home/f/.local/share 0750 f users -"
      "d /persist/home/f/.local/share/keyrings 0750 f users -"
      "d /persist/home/f/.local/share/direnv 0750 f users -"
      "d /persist/home/f/.local/bin 0750 f users -"

      "d /persist/home/f/.config 0750 f users -"
      ''d /persist/home/f/.config/Code 0750 f users -''
      ''d /persist/home/f/.config/"Code - Insiders" 0750 f users -''
      ''d /persist/home/f/.config/VSCodium 0750 f users -''
    ];
  };
}
