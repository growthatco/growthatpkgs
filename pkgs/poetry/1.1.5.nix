{ versions ? import ../../versions.nix { } }:

let
  pkgs = versions.n860b5;
in
pkgs.poetry
