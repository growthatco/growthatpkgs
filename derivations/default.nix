{ sources ? import ./../nix { } }:

let inherit (sources) nixpkgs;
in rec {
  build-hashi-corp-package =
    nixpkgs.callPackage ./_build-hashi-corp-package.nix;
}
