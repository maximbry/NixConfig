{ pkgs, config, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
  };
}
