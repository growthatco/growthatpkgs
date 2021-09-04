{ constants ? import ./constants.nix, sources ? import ../nix { } }:
let inherit (sources) nixpkgs;
in { version }: constants.root-dir + "/modules/nixpkgs-${version}"
