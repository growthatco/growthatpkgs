{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._n860b5;
in
pkgs.nodejs-16_x
