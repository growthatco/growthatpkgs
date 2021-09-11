{ sources ? import ./sources.nix }:
let overlay = _: pkgs: { inherit (import sources.niv { }) niv; };
in rec {
  nixpkgs = import sources.nixpkgs {
    overlays = [ overlay ];
    config = { };
  };

  inherit (sources) 860b56be91fb874d48e23a950815969a7b832fbc;
}
