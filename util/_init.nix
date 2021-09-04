{ constants ? import ./constants.nix, sources ? import ../nix { } }:

let inherit (sources) nixpkgs;
in { tool, version }:
(import (constants.root-dir + "/pkgs/${tool}/${version}.nix"))
