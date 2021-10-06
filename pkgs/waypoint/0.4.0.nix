{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._n860b5;
in
pkgs.waypoint
