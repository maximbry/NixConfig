{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    zotero
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    bottles
    nekoray
    doom2d-forever
    doom2d-forever-headless
  ];
}