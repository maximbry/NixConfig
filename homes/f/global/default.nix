{ inputs, lib, pkgs, config, outputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.impermanence.nixosModules.home-manager.impermanence
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      trusted-users = [ "root" "@admin" "@wheel" "f" ];
      extra-substituters =
        [ "https://nyx.chaotic.cx/" "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs = { enable = true; };
      userName = "maximbry";
      userEmail = "github@maximbry.anonaddy.com";
    };
  };

  home = {
    username = lib.mkDefault "f";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "VirtualBox VMs"
          "VM"
          "Templates"
          "Public"
          "Desktop"
          "NixConfig"
          "Git"
          "Vault"
          "Torrents"
          ".gnupg"
          ".ssh"
          ".nixops"
          ".mozilla"
          ".vscode"
          ".vscode-insiders"
          ".vscodium"

          ".local/share/keyrings"
          ".local/share/direnv"
          ".local/share/tor-browser"
          ".local/share/qBittorrent"
          ".local/share/Anki2"
          ".local/share/Anki"
          ".local/share/tg"
          ".local/bin"

          ".config/chromium"
          ".config/Code"
          ''.config/"Code - Insiders"''
          ".config/VSCodium"
          ".config/Bitwarden"
          ".config/Bitwarden CLI"
          ".config/qBittorrent"
          ".config/tg"
        ];
        allowOther = true;
      };
    };
  };
}
