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
    # <growthatpkgs>
    growthatpkgs.act
    growthatpkgs.nodejs
    growthatpkgs.poetry
    growthatpkgs.python
    growthatpkgs.rnix-lsp
    growthatpkgs.shfmt
  ];
  shellHook = ''
    unset PYTHONPATH
  '';
}
