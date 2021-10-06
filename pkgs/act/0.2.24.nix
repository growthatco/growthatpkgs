{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._ee084c;
in
pkgs.act
