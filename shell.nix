{ sources ? import ./nix { }, growthatpkgs ? import ./packages.nix { } }:

let
  inherit (sources) nixpkgs;
in
nixpkgs.mkShell rec {
  name = "growthatpkgs";
  env = nixpkgs.buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    nixpkgs.rnix-lsp
    # <growthatpkgs>
    growthatpkgs.act
    growthatpkgs.nixpkgs-fmt
    growthatpkgs.nodejs
    growthatpkgs.python
  ];
  shellHook = ''
    unset PYTHONPATH
  '';
}
