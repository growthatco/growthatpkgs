{ sources ? import ../../nix { } }:

let
  pkgs = sources.revisions._9c28f1;
in
pkgs.rnix-lsp
