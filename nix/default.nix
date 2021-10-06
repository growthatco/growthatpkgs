{ sources ? import ./sources.nix }:

let
  overlay = _: pkgs: { inherit (import sources.niv { }) niv; };
in
rec {
  nixpkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

  revisions = {
    _9c28f1 = import sources._9c28f1 { };
    _ee084c = import sources._ee084c { };
    _n860b5 = import sources._n860b5 { };
  };
}
