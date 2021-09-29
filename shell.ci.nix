{ sources ? import ./nix { }, growthatpkgs ? import ./packages.nix { } }:

let
  inherit (sources) nixpkgs;
in
nixpkgs.mkShell rec {
  name = "ci.growthatpkgs";
  env = nixpkgs.buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    # <growthatpkgs>
    growthatpkgs.act
    growthatpkgs.bazel
    growthatpkgs.clippy
    growthatpkgs.consul
    growthatpkgs.go
    growthatpkgs.golangci-lint
    growthatpkgs.google-cloud-sdk
    growthatpkgs.helm
    growthatpkgs.jq
    growthatpkgs.k9s
    growthatpkgs.nixpkgs-fmt
    growthatpkgs.nodejs
    growthatpkgs.nomad
    growthatpkgs.openjdk
    growthatpkgs.python
    growthatpkgs.rust
    growthatpkgs.rustfmt
    growthatpkgs.shfmt
    growthatpkgs.skaffold
    growthatpkgs.waypoint
    growthatpkgs.yamllint
  ];
  shellHook = "unset GOPATH";
}
