{ sources ? import ./sources.nix }:

let overlay = _: pkgs: { inherit (import sources.niv { }) niv; };
in rec {
  nixpkgs = import sources.nixpkgs {
    overlays = [ overlay ];
    config = { };
  };
  n860b5 = import sources.n860b5 { };
}
