{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._n860b5;
in
pkgs.google-cloud-sdk-gce
