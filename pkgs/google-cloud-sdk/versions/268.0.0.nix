{ callPackage
, withGce ? false }:

let
  build = callPackage ../default.nix {
    inherit withGce;
  };
in
  build {
    version = "286.0.0";
  }