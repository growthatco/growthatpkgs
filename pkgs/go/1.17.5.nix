{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._c82b46;
in
pkgs.go_1_17
