{ constants ? import ./constants.nix, sources ? import ../nix { } }:
{ tool, version, local ? false }:

let
  inherit (sources) nixpkgs;
  path = constants.root-dir + "/pkgs/${tool}/${version}.nix";
in if local then nixpkgs.callPackage path { } else import path

