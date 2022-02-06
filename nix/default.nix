{ sources ? import ./sources.nix }:

let
  overlay = _: pkgs: { inherit (import sources.niv { }) niv; };
in
rec {
  nixpkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

  revisions = {
    # 9c28f1f95835f774243efcea40befe766dd37b5c
    _9c28f1 = import sources._9c28f1 { };
    # ee084c02040e864eeeb4cf4f8538d92f7c675671
    _ee084c = import sources._ee084c { };
    # 860b56be91fb874d48e23a950815969a7b832fbc
    _n860b5 = import sources._n860b5 { };
    # c82b46413401efa740a0b994f52e9903a4f6dcd5
    _c82b46 = import sources._c82b46 { };
  };
}
