{ sources ? import ./nix { }, util ? import ./util { } }:

let
  inherit (sources) nixpkgs;
in
rec {
  act = act-0-2-24;
  act-0-2-24 = util.init
    {
      tool = "act";
      version = "0.2.24";
    }
    { };

  bazel = bazel-4-1-0;
  bazel-4-1-0 = util.init
    {
      tool = "bazel";
      version = "4.1.0";
    }
    { };
  bazel-3-7-2 = util.init
    {
      tool = "bazel";
      version = "3.7.2";
    }
    { };

  clippy = clippy-1-52-1;
  clippy-1-52-1 = util.init
    {
      tool = "clippy";
      version = "1.52.1";
    }
    { };

  consul = consul-1-10-0;
  consul-1-10-0 = util.init
    {
      tool = "consul";
      version = "1.10.0";
    }
    { };

  direnv = direnv-2-28-0;
  direnv-2-28-0 = util.init
    {
      tool = "direnv";
      version = "2.28.0";
    }
    { };

  go = go-1-17-5;
  go-1-16-5 = util.init
    {
      tool = "go";
      version = "1.16.5";
    }
    { };
  go-1-17-5 = util.init
    {
      tool = "go";
      version = "1.17.5";
    }
    { };

  golangci-lint = golangci-lint-1-41-1;
  golangci-lint-1-41-1 = util.init
    {
      tool = "golangci-lint";
      version = "1.41.1";
    }
    { };

  google-cloud-sdk = google-cloud-sdk-345-0-0;
  google-cloud-sdk-345-0-0 = util.init
    {
      tool = "google-cloud-sdk";
      version = "345.0.0";
    }
    { };

  helm = helm-3-6-1;
  helm-3-6-1 = util.init
    {
      tool = "helm";
      version = "3.6.1";
    }
    { };

  jq = jq-1-6;
  jq-1-6 = util.init
    {
      tool = "jq";
      version = "1.6";
    }
    { };

  k9s = k9s-0-24-10;
  k9s-0-24-10 = util.init
    {
      tool = "k9s";
      version = "0.24.10";
    }
    { };

  lorri = lorri-1-5-0;
  lorri-1-5-0 = util.init
    {
      tool = "lorri";
      version = "1.5.0";
    }
    { };

  nixpkgs-fmt = nixpkgs-fmt-1-2-0;
  nixpkgs-fmt-1-2-0 = util.init
    {
      tool = "nixpkgs-fmt";
      version = "1.2.0";
    }
    { };

  nodejs = nodejs-17-3-0;
  nodejs-16-13-1 = util.init
    {
      tool = "nodejs";
      version = "16.13.1";
    }
    { };
  nodejs-16-4-0 = util.init
    {
      tool = "nodejs";
      version = "16.4.0";
    }
    { };
  nodejs-17-3-0 = util.init
    {
      tool = "nodejs";
      version = "17.3.0";
    }
    { };    

  nomad = nomad-1-0-8;
  nomad-1-0-8 = util.init
    {
      tool = "nomad";
      version = "1.0.8";
    }
    { };

  poetry = poetry-1-1-5;
  poetry-1-1-5 = util.init
    {
      tool = "poetry";
      version = "1.1.5";
    }
    { };

  python = python-3-9-4;
  python-3-7-10 = util.init
    {
      tool = "python";
      version = "3.7.10";
    }
    { };
  python-3-9-4 = util.init
    {
      tool = "python";
      version = "3.9.4";
    }
    { };

  rnix-lsp = rnix-lsp-0-2-1;
  rnix-lsp-0-2-1 = util.init
    {
      tool = "rnix-lsp";
      version = "0.2.1";
    }
    { };

  rust = rust-1-52-1;
  rust-1-52-1 = util.init
    {
      tool = "rust";
      version = "1.52.1";
    }
    { };

  rustfmt = rustfmt-1-52-1;
  rustfmt-1-52-1 = util.init
    {
      tool = "rustfmt";
      version = "1.52.1";
    }
    { };

  shfmt = shfmt-3-3-0;
  shfmt-3-3-0 = util.init
    {
      tool = "shfmt";
      version = "3.3.0";
    }
    { };

  skaffold = skaffold-1-20-0;
  skaffold-1-20-0 = util.init
    {
      tool = "skaffold";
      version = "1.20.0";
    }
    { };

  waypoint = waypoint-0-4-0;
  waypoint-0-4-0 = util.init
    {
      tool = "waypoint";
      version = "0.4.0";
    }
    { };

  yamllint = yamllint-1-26-1;
  yamllint-1-26-1 = util.init
    {
      tool = "yamllint";
      version = "1.26.1";
    }
    { };
}
