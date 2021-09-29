{ constants ? import ./constants.nix, sources ? import ../nix { } }:
{ tool, version, local ? false }:
{ ... }@args:

let
  inherit (sources) nixpkgs;
  path = constants.root-dir + "/pkgs/${tool}/${version}.nix";
in
if local then nixpkgs.callPackage path args else import path args

