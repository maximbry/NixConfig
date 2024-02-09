{ pkgs, inputs, ... }: {
  home.packages = let genpw = pkgs.writeShellScriptBin "genpw" "${pkgs.diceware}/bin/diceware -n 3 -d _ | tr '[:lower:]' '[:upper:]' | tr '_' 'z' | tr '\n' 'z'"; in with pkgs; [
    zotero
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    bottles
    nekoray
    doom2d-forever
    doom2d-forever-headless
    genpw
    telegram-desktop
    pkgs.inputs.nixpkgs-master.pdfannots2json
    doom2d-forever-editor
    cntr
  ];
}