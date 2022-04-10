{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._c82b46;
in
pkgs.nodejs-17_x
