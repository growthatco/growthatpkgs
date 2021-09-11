{ sources ? import ./nix { } }:

let
  inherit (sources) n860b5;
in rec {
  act = act-0-2-23;
  act-0-2-23 = n860b5.act;

  bazel = bazel-4-1-0;
  bazel-4-1-0 = n860b5.bazel_4;
  bazel-3-7-2 = n860b5.bazel;

  clippy = clippy-1-52-1;
  clippy-1-52-1 = n860b5.clippy;

  consul = consul-1-10-0;
  consul-1-10-0 = n860b5.consul;

  go = go-1-16-5;
  go-1-16-5 = n860b5.go;

  golangci-lint = golangci-lint-1-41-1;
  golangci-lint-1-41-1 = n860b5.golangci-lint;

  google-cloud-sdk = google-cloud-sdk-345-0-0;
  google-cloud-sdk-345-0-0 = n860b5.google-cloud-sdk-gce;

  helm = helm-3-6-1;
  helm-3-6-1 = n860b5.helm;

  jq = jq-1-6;
  jq-1-6 = n860b5.jq;

  k9s = k9s-0-24-10;
  k9s-0-24-10 = n860b5.k9s;

  nixfmt = nixfmt-0-4-0;
  nixfmt-0-4-0 = n860b5.nixfmt;

  nodejs = nodejs-16-4-0;
  nodejs-16-4-0 = n860b5.nodejs-16_x;

  nomad = nomad-1-0-8;
  nomad-1-0-8 = n860b5.nomad;

  openjdk = openjdk-16-36;
  openjdk-11-0-10-9 = n860b5.jdk11;
  openjdk-16-36 = n860b5.jdk;

  python = python-3-9-4;
  python-3-7-10 = n860b5.python37Full;
  python-3-9-4 = n860b5.python39;

  rust = rust-1-52-1;
  rust-1-52-1 = n860b5.rustc;

  rustfmt = rustfmt-1-52-1;
  rustfmt-1-52-1 = n860b5.rustfmt;

  shfmt = shfmt-3-3-0;
  shfmt-3-3-0 = n860b5.shfmt;

  skaffold = skaffold-1-20-0;
  skaffold-1-20-0 = n860b5.skaffold;

  waypoint = waypoint-0-4-0;
  waypoint-0-4-0 = n860b5.waypoint;

  yamllint = yamllint-1-26-1;
  yamllint-1-26-1 = n860b5.yamllint;
}
