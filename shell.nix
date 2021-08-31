{ sources ? import ./nix { }, growthatpkgs ? import ./packages.nix { } }:
let
  inherit (sources)
    nixpkgs
  ;
in
nixpkgs.mkShell rec {
  name = "growthatpkgs";
  env = nixpkgs.buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    # <growthatpkgs>
    growthatpkgs.bazel
    growthatpkgs.consul
    # growthatpkgs.clippy
    growthatpkgs.go
    ## growthatpkgs.golangci-lint
    ## growthatpkgs.google-cloud-sdk
    ## growthatpkgs.helm
    ## growthatpkgs.jq
    ## growthatpkgs.k9s
    # growthatpkgs.mirror
    ## growthatpkgs.nodejs
    # growthatpkgs.nomad
    # growthatpkgs.openjdk
    ## growthatpkgs.python
    # growthatpkgs.rustc
    growthatpkgs.skaffold
    growthatpkgs.waypoint
  ];
  shellHook = "unset GOPATH";
}
